Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3LNXkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 18:40:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3LNXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 18:40:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 03/16] ARM: dts: provide DMA config to pxamci
Date: Sun, 15 Dec 2013 00:39:46 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-mmc@vger.kernel.org
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <201312142006.26979.arnd@arndb.de> <1387049660.7152.317.camel@host5.omatika.ru>
In-Reply-To: <1387049660.7152.317.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312150039.46681.arnd@arndb.de>
X-Provags-ID: V02:K0:D+IZESZonT/S8Gr1aA6vmbVnz9RPUOwAL8UpaLuji8E
 afS2l+HiR81MFhR1CHy69IKXLqyP1P6mDkAb8JrpiHJ3npQKYO
 SR4b2IhKtDb7ePzBcGt5pEJQibPnfa4BKytrr62v5IFNVKcXV5
 XlwSBZJqXocokaLNBLd3Eivr1emYFewF2vkx9Q7tcY9I9THC9K
 0iudYW8PkaVOW8tH1wDVSbGOefi/qEeJW3HsNRrdoDBzjY6inq
 bUlqve3tZakeugwEF2PocEsFlgRq7bZTp35uES1vk0MD1CGPjt
 DqJIDslO3BfaqTSlrxEm/25gHF6uKWEIbvICzJzqKhwI1ycCQS
 J1PES33Hh6wifPFpnM3Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 December 2013, Sergei Ianovich wrote:
> On Sat, 2013-12-14 at 20:06 +0100, Arnd Bergmann wrote:
> > On Friday 13 December 2013, Sergei Ianovich wrote:
> > > Non-dts implementation supply required DMA channel numbers as
> > > IORESOURCE_DMA. However, there is was no way to get them from
> > > device tree.
> > 
> > Please update this changeset comment, I think it still refers to
> > the earlier version.
> 
> ---
> Non-dts implementation supply required DMA channel numbers as
> IORESOURCE_DMA. We can also get them from the device tree, if it
> is present.
> ---
> 
> Is this fine?

I would mention that the binding is designed to work with the dmaengine
framework as soon as we have figured out how to make that work without
the problems you found.

> Should I post v3, if so? 

I'd wait a little longer for more comments.

	Arnd
