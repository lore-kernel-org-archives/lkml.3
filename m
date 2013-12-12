Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3LLUnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:43:23 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60248 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3LLUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:43:21 -0500
MIME-Version: 1.0
In-Reply-To: <52A7AC4A.8010504@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<1380846199-12829-4-git-send-email-syin@broadcom.com>
	<CAEPRUYqfpdp1GqxBgx-q=hyvQDe4uyi6okzHPW2QmfmPG_Z3NQ@mail.gmail.com>
	<525FFA40.9050901@wwwdotorg.org>
	<CAEPRUYq5DA982AqAmrUpsb3qc30VaFBawaXKTp2pcDvdbM-S1g@mail.gmail.com>
	<52A7AC4A.8010504@broadcom.com>
Date: Thu, 12 Dec 2013 21:43:20 +0100
Message-ID: <CACRpkdYYQFqT0kfpdkAGYKAZMGmfqE55BBk+P6bDC1wxcExQhw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Markus Mayer <mmayer@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 1:05 AM, Sherman Yin <syin@broadcom.com> wrote:

> I was just trying to move "select PINCTRL" to a defconfig as Christian
> suggested.  However, CONFIG_PINCTRL is not selectable by a defconfig file
> (the option will be gone by the time .config is generated), even though
> PINCTRL has no dependency.  Also, this option is not visible in menuconfig.
>
> I found that by adding a string after "bool" in the PINCTRL config
> definition (see diff below), CONFIG_PINCTRL will be selectable in a
> defconfig file and this option will also be visible in menuconfig.
>
> Was this intentional or is this a bug?  To address Christian's comment, I'll
> need to add the following patch.

This was intentional.

Pin control was considered an intrinsic of specific embedded systems
and not to be broadcasted to anyone running menuconfig.

But if you really need this, we can discuss it.

Yours,
Linus Walleij
