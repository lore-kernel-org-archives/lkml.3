Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3BJOF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 09:05:57 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56603 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3BJOF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 09:05:56 -0500
Date: Sun, 10 Feb 2013 15:05:54 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] -rc7/-rc4+: unable to USB boot - enumeration
 partially broken (was: Linux v3.8-rc7)
Message-ID: <20130210140554.GA5299@rhlx01.hs-esslingen.de>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130210001442.GA5744@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130210001442.GA5744@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 10, 2013 at 01:14:42AM +0100, Andreas Mohr wrote:
> After the reinstall I tried to get a current -rc (-rc4+) working.
> To my surprise initramfs USB boot failed, completely.
> (the tell-tale sign that it likely is a regression was that the same 3.7.0
> kernel that had been working previously, built via make oldconfig of
> the **-rc** .config and with identical commands as -rc - using make install -
> was then again found to be booting fine!)

Regression sorta confirmed now. -rc3 with a fully suitable .config does
not boot either. Will start bisection. Will take ages.

Andreas Mohr
