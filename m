Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaJHLBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:01:12 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:53881 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaJHLBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:01:09 -0400
X-IronPort-AV: E=Sophos;i="5.04,677,1406617200"; 
   d="scan'208";a="47924419"
Message-ID: <54351972.5030803@broadcom.com>
Date: Wed, 8 Oct 2014 04:01:06 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH 4/6] ARM: cygnus defconfig : Initial defconfig for Broadcom
 Cygnus SoC
References: <1412746025-11998-5-git-send-email-sbranden@broadcom.com> <1996601.jhvNxNYxnl@wuerfel>
In-Reply-To: <1996601.jhvNxNYxnl@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-08 12:58 AM, Arnd Bergmann wrote:
> On Tuesday 07 October 2014 22:27:03 Scott Branden wrote:
>> From: Jonathan Richardson <jonathar@broadcom.com>
>>
>> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
>> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>
> Do you actually need a separate defconfig?
>
> If possible, just add your drivers to multi_v7_defconfig, otherwise
> include a justification in the patch changelog why your platform
> should have its own defconfig file.
We need a separate defconfig so that customers and developers have some 
chance of understanding what kernel drivers apply to their SoC.  That 
way they can optimize kernel size if desired.  Will update patch 
changelog in next version.
>
> 	Arnd
>

