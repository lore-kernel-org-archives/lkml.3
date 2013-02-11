Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3BKP0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:26:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61813 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3BKP0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:26:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Mon, 11 Feb 2013 15:26:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302072312.45988.arnd@arndb.de> <CAHTX3dK1Buz3Yh8NTrpsB2X6_17EYT5augOsaLy8_OZQHAOUyw@mail.gmail.com>
In-Reply-To: <CAHTX3dK1Buz3Yh8NTrpsB2X6_17EYT5augOsaLy8_OZQHAOUyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111526.37892.arnd@arndb.de>
X-Provags-ID: V02:K0:r/LkcEQHbJQ+TH1NSK21oi0KjiyNJcutdp/LCIF0J0/
 KfRXTfnGNXLtrTXK1Szz++hqG0g8dryT+ylxqcTUjL06m/2JP3
 7K4dAXmVAOxgpq5V67AjPNW0NQ3Yt4JZn1kBVOJ8y8wnZWg8/c
 PdRLMNg+W0U1nTJwKbT4/sfBu0O8klsiPnntN0YFxf0Ng7fBxa
 qcnM1j3dY5udvm046kNJy5UqCSS75wIabOmwD5oe3VnQ4Nf8MS
 ha0B2ndcfODCLSkABXlpvisJ5ZvP8vFBZj5ZXic/RMe4BUnwI8
 NixepZXBDdeEMrL4I7lhVT3i3TvluWndbEo0W7RnKQ3ETjhVft
 MDj4uFapPPvtCTKMF7dI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013, Michal Simek wrote:
> 
> 2013/2/8 Arnd Bergmann <arnd@arndb.de>:
> > On Thursday 07 February 2013, Michal Simek wrote:
> >> Subject: "asm-generic: io: Fix ioread16/32be and iowrite16/32be"
> >
> > Ok, thanks. If you don't mind, I think this can just go with the other patches
> > for xsysace that come out of this discussion.
> 
> I want to move microblaze to use this asm-generic/io.h that's why I
> prefer to send
> this with microblaze patch directly to Linus. For me this make more sense that
> with sending block device driver changes.
> 
> What do you think?

Sure, please do it that way. My policy for asm-generic patches is that they
I prefer to have them go through whatever tree needs them, I was just confused
about which one that would be in this case.

	Arnd
