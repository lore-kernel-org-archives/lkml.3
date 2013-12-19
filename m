Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3LSANR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:13:17 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:2819 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3LSANP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:13:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,510,1384329600"; 
   d="scan'208";a="3903268"
Message-ID: <52B239EE.6010601@broadcom.com>
Date: Wed, 18 Dec 2013 16:12:30 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbn?= =?ISO-8859-1?Q?er?= 
	<heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/6] ARM: pinctrl: Add Broadcom Capri pinctrl driver
References: <1381174108-25168-1-git-send-email-syin@broadcom.com> <1386787041-6035-1-git-send-email-syin@broadcom.com> <1386787041-6035-6-git-send-email-syin@broadcom.com> <CACRpkdaeZCodKv6R+4ZS3o-5u=QQuV3JidEp7uaLsN9aYG7bqA@mail.gmail.com> <20131213102252.GS11044@sirena.org.uk>
In-Reply-To: <20131213102252.GS11044@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-13 02:22 AM, Mark Brown wrote:
> On Thu, Dec 12, 2013 at 09:54:50PM +0100, Linus Walleij wrote:
>
>> This is a reimplementation of regmap for MMIO.
>> See drivers/base/regmap/regmap-mmio.c
>> Notice how regmap_update_bits() is used throughout the
>> kernel.
>
>> If you want to do this, use regmap.
>
> Or if this is very performance sensitive (which I'd not expect for
> pinctrl) there's a helper in review at the minute which just uses a
> spinlock.
>

Thanks Mark.  It's not expected to be performance sensitive, so I'll 
probably go with regmap.

Regards,
Sherman
