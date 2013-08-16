Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3HQANO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:13:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33899 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab3HQANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:13:08 -0400
Message-ID: <520EADFC.5000607@wwwdotorg.org>
Date: Fri, 16 Aug 2013 16:55:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: ohad@wizery.com, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Subject: Re: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex
 block
References: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 01:09 PM, Kumar Gala wrote:
> Add driver for Qualcomm MSM Hardware Mutex block that exists on newer MSM
> SoC (MSM8974, etc).

> diff --git a/Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt b/Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt

> +Required properties:
> +- compatible: should be "qcom,tcsr-mutex"
> +- reg: Should contain registers location and length of mutex registers
> +- reg-names:
> +	"mutex-base"  - string to identify mutex registers
> +- qcom,num-locks: the number of locks/mutexes supported

Doesn't the block support any interrupts? I suppose the interrupts
property can be optional though even if it does.

Aside from the comments re: reg-names, this binding seems fine.
