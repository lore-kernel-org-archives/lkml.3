Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3JAGaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:30:09 -0400
Received: from vex.ruff.mobi ([46.167.245.136]:57959 "EHLO vex.ruff.mobi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3JAGaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:30:07 -0400
Date: Tue, 1 Oct 2013 08:29:25 +0200
From: "Ruslan N. Marchenko" <me@ruff.mobi>
To: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Regression in 2fdac010
 drivers/net/ethernet/via/via-velocity.c: update napi implementation
Message-ID: <20131001062925.GA9458@ruff.mobi>
Mail-Followup-To: Julia Lawall <julia.lawall@lip6.fr>,
	linux-kernel@vger.kernel.org
References: <20130930071531.GA13037@ruff.mobi>
 <alpine.DEB.2.02.1309301353150.2036@localhost6.localdomain6>
 <20130930135427.GA19660@ruff.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930135427.GA19660@ruff.mobi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 03:54:27PM +0200, Ruslan N. Marchenko wrote:
> On Mon, Sep 30, 2013 at 01:54:06PM +0200, Julia Lawall wrote:
> > On Mon, 30 Sep 2013, Ruslan N. Marchenko wrote:
> > 
> > > Hi Julia et al.,
> > > 
> > > With this commit VIA NANO board get CPU lockup in random places on any network activity.
> > > .
> > > Reverting the patch allows me to boot without problems even from latest Linus trunk and send this mail.
> > 
> > You can find the discussion and improved patch in this thread:
> > 
> > http://www.spinics.net/lists/netdev/msg251287.html
> > Bug - regression - Via velocity interface coming up freezes kernel
> > From: Dirk Kraft <dirk.kraft@xxxxxxxxx>
> > Date: Sun, 22 Sep 2013 19:28:52 +0200
> > 
> > julia
> 
> Oops, sorry, somehow I missed it even though 've been searching for via-velocity regression.
> Will give a try to new proposed patch as well.
> 
 and short confirmation adding patch from Francois Romieu works on current -rc3+

Regards,
Ruslan
