Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab3BLQHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:07:31 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49553 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3BLQH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:07:29 -0500
Date: Tue, 12 Feb 2013 17:07:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] -rc7/-rc4+: unable to USB boot - enumeration
 partially broken (was: Linux v3.8-rc7)
Message-ID: <20130212160727.GA15857@rhlx01.hs-esslingen.de>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130210001442.GA5744@rhlx01.hs-esslingen.de>
 <20130210140554.GA5299@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130210140554.GA5299@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 03:05:54PM +0100, Andreas Mohr wrote:
> Regression sorta confirmed now. -rc3 with a fully suitable .config does
> not boot either. Will start bisection. Will take ages.

Down to 91 commits (all in USB land!), around 7 steps left.
Pretty certain of a valid regression now. Things did properly do the
good/good/bad/bad/good... dance.

Oh so lovely if you're constrained to >= 5 hour build times,
with almost every bisection step doing reduction of the config set
in larger areas, to try to finally hit <= 2 hours...
(7 steps --> ~ one day)

Andreas Mohr
