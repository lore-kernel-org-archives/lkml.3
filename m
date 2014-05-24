Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaEXRxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:53:33 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57062 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaEXRvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:51:40 -0400
X-Auth-Info: xr6pmiN/vBLpyH5cgAja1NcU3MHS8rAookWjaxq9Nug=
From: Marek Vasut <marex@denx.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Sat, 24 May 2014 13:26:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.12.4; x86_64; ; )
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <537E3E2F.7000407@gmail.com> <201405231246.10365.arnd@arndb.de>
In-Reply-To: <201405231246.10365.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201405241326.26260.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 23, 2014 at 12:46:10 PM, Arnd Bergmann wrote:
> On Thursday 22 May 2014, Corentin LABBE wrote:
> > Le 22/05/2014 17:28, Arnd Bergmann a écrit :
> > > On Thursday 22 May 2014 17:09:56 LABBE Corentin wrote:
> > >> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > > 
> > > My feeling is that this should either be one driver that provides
> > > all five algorithms unconditionally, or five drivers that are each
> > > separate loadable modules and based on top of a common module
> > > that only exports functions but has no active logic itself
> > 
> > I agree for the split.
> > It was my first intention but I feared to add too many files.
> > So I propose to split in 6, sunxi-ss-hash.c, sunxi-ss-des.c,
> > sunxi-ss-aes.c, sunxi-ss-rng.c, sunxi-ss-common.c and sunxi-ss.h Does
> > can I add a sunxi-ss directory in drivers/crypto ?
> 
> Yes, I think a subdirectory would be best.

Full ACK on this one. Use drivers/crypto/sunxi-ss/ .
[...]

Best regards,
Marek Vasut
