Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3HONfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:35:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47554 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3HONfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:35:51 -0400
Message-ID: <1376573746.18617.45.camel@hornet>
Subject: Re: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW
 Mutex block
From: Pawel Moll <pawel.moll@arm.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: "ohad@wizery.com" <ohad@wizery.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Date: Thu, 15 Aug 2013 14:35:46 +0100
In-Reply-To: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
References: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 15 Aug 2013 13:35:46.0856 (UTC) FILETIME=[59210280:01CE99BC]
X-MC-Unique: 113081514354900201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 20:09 +0100, Kumar Gala wrote:
> +Required properties:
> +- compatible: should be "qcom,tcsr-mutex"
> +- reg: Should contain registers location and length of mutex registers
> +- reg-names:
> +	"mutex-base"  - string to identify mutex registers

Just out of curiosity, why is reg-names required? Especially if there
seem to be only one set of registers?

Paweł


