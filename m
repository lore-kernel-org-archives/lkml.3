Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaEHSuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:50:25 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:65191 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaEHSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:50:23 -0400
Message-ID: <536BD1F3.8010602@linaro.org>
Date: Thu, 08 May 2014 13:50:27 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: devicetree@vger.kernel.org
CC: mark.rutland@arm.com, sboyd@codeaurora.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, lorenzo.pieralisi@arm.com,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        rvaswani@codeaurora.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] devicetree: bindings: separate CPU enable method descriptions
References: <1399574905-6478-1-git-send-email-elder@linaro.org>
In-Reply-To: <1399574905-6478-1-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 01:48 PM, Alex Elder wrote:
> The bindings for CPU enable methods are defined in ".../arm/cpus.txt".  As
> additional 32-bit ARM CPUS are converted to use the "enable-method" CPU
> property to imply a particular set of SMP operations to use, the list of these
> methods is likely to become unwieldy.  The current documentation already
> contains several property descriptions that are meaningful only for certain
> enable methods.
...

I forgot to mention, this patch is available here:
	http://git.linaro.org/landing-teams/working/broadcom/kernel.git
        Branch review/enable-method-bindings-v2

					-Alex
