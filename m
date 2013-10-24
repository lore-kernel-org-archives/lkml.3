Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3JXTth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:49:37 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46227 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3JXTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <1382641926.16515.2.camel@lolumad>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
	<1382461643-16790-4-git-send-email-lisovy@gmail.com>
	<20131023072738.GI2839@S2101-09.ap.freescale.net>
	<1382641926.16515.2.camel@lolumad>
Date: Thu, 24 Oct 2013 14:49:33 -0500
Message-ID: <CAHCPf3vB+HYkFoBYcbVM6Ecp+8BSApG2JZi1PRwc7ag6ygszOw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: dts: i.MX53: dts for Voipac x53-dmm-668 module
From: Matt Sealey <neko@bakuhatsu.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, pisa@cmp.felk.cvut.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 2:12 PM, Rostislav Lisovy <lisovy@gmail.com> wrote:
> Dear Shawn;
> Thank you for your comments.
> Should I also add Voipac to
> Documentation/devicetree/bindings/vendor-prefixes.txt?

I would agree with that, but why is your chosen prefix "vp" instead of
"voipac" anyway?

-- 
Matt Sealey <neko@bakuhatsu.net>
