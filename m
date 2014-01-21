Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaAUMfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:35:12 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65371 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaAUMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:35:07 -0500
MIME-Version: 1.0
In-Reply-To: <52DD75B1.3090701@broadcom.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-4-git-send-email-syin@broadcom.com>
	<CACRpkdaPZrR=kEknr3YKDWLd_E+o22Yn19ei7iT6cdbYdbeZ2w@mail.gmail.com>
	<52D98B99.5050604@broadcom.com>
	<20140118025600.GS31049@beef>
	<CACRpkdYAANtY=9QtDnYNZLSrF09nTWUH4nK5oJ7mzznS+_=bHA@mail.gmail.com>
	<52DD75B1.3090701@broadcom.com>
Date: Tue, 21 Jan 2014 13:35:05 +0100
Message-ID: <CACRpkdYjLPAvt8-ZiZfAhUw6RbjE+1dYjtjfq0bjRkyYhm=9xw@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Matt Porter <mporter@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 8:14 PM, Sherman Yin <syin@broadcom.com> wrote:

> I'll confirm the new name with Matt before sending out another patch. Which
> would work better for you - a) a set of patches replacing my previous ones,
> b) a set of patches on top of my previous ones, c) a single patch on top of
> my previous ones? d) something else?

(c)

The tree goes upstream now, you have to make this fix on top.

Yours,
Linus Walleij
