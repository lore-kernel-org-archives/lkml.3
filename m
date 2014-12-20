Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaLTQ2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:28:14 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48163 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbaLTQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:28:11 -0500
X-Sasl-enc: e/2uvTTE1sUPBLMY+jAkDrepckD2TLVfPfRsR2Bz1+E0 1419092890
Date: Sat, 20 Dec 2014 14:28:04 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>, mjg59@srcf.ucam.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Message-ID: <20141220162804.GA7872@khazad-dum.debian.net>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
 <201412052207.35676@pali>
 <20141203180329.GB20370@vmdeb7>
 <201412201010.18151@pali>
 <20141220151108.GA11752@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141220151108.GA11752@amd>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014, Pavel Machek wrote:
> > > > Ok, I agree that it is subjective how serious it is...
> > > > Just to remind that patch fixing problem described in
> > > > 
> > > > http://www.spinics.net/lists/platform-driver-x86/msg05922.ht
> > > > ml
> > > > http://www.spinics.net/lists/platform-driver-x86/msg05924.h
> > > > tml
> > > 
> > > I don't have any objection to sending this back to stable.
> > > Stable is for fixing REAL bugs, as opposed to theorhetical
> > > races, etc. This is a "real" bug.
> > > 
> > > As to not chaning behavior, if it's OK for mainline, it's OK
> > > for stable. At least that is my understanding of it. Folks
> > > are free to verify with Greg if they disagree.
> > 
> > Darren, so how you decided? Now when patches are in linus tree, 
> > are you going to send them to stable tree?
> 
> Please don't. -stable is for serious mainline bugs people are actually
> hitting. Null pointer dereference counts, if people actually hit
> it. This is more behaviour change, and yes, the new behaviour is
> better, but it is really different class.

Sometimes the old behavior is something that is a major pain for users and
userspace.  In that case, where the new behavior fixes really annoying
usecase bugs, the fix belongs in -stable IMHO.

Broken behavior hits, by definition, every user of the feature after all.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
