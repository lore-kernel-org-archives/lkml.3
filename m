Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaBMIXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:23:21 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44205 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaBMIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:23:20 -0500
Date: Thu, 13 Feb 2014 08:23:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Laszlo Papp <lpapp@kde.org>, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, k.kozlowski@samsung.com,
        sachin.kamat@linaro.org, jdelvare@suse.de, linux@roeck-us.net
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
Message-ID: <20140213082311.GA32508@lee--X1>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
 <20140212175018.GJ28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140212175018.GJ28112@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laszlo,

> > +const struct regmap_config max665x_regmap_config = {
> > +	.reg_bits = 5,
> > +};
> 
> This would normally be static too, and I'd *really* expect to see a
> val_bits set here.  I'm a bit surprised this works without one.

Mark (privately) mentioned to me that this patch can't possibly work
given the current Regmap configuration. Patches are accepted into
Mainline based on the premise that they are fully tested and working,
_prior_ to submitting [1].

It's also pretty pointless having an MFD driver without any
children, so unless (at least one of) the child device drivers have
been accepted by pull-time, your work will not be part of the
pull-request headed for Mainline.

Please inform me of your plans as you with to proceed.

[] Documentation/SubmitChecklist

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
