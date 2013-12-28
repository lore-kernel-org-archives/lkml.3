Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3L1Hnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 02:43:35 -0500
Received: from hofr.at ([212.69.189.236]:41613 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab3L1Hnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 02:43:33 -0500
Date: Sat, 28 Dec 2013 08:43:31 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Mike Galbraith <bitbucket@online.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20131228074331.GA26538@opentech.at>
References: <20131223225017.GA8623@linutronix.de> <20131227200024.GA19505@opentech.at> <1388201449.5387.70.camel@marge.simpson.net> <1388202516.5387.79.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388202516.5387.79.camel@marge.simpson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Dec 2013, Mike Galbraith wrote:

> On Sat, 2013-12-28 at 04:30 +0100, Mike Galbraith wrote:
> 
> > (Less than wonderful changelogs probably comes from the fact that
> > maintaining -rt out of tree is time consuming as all hell.  Everybody
> > gets to breaks it, a couple guys get to fix it up again and again.)
> 
> P.S.  try rolling your tree forward to master or tip for entertainment,
> you'll see what I mean.  Hi Peter, Rik.. other breakers of worlds :)
>
protesting exernal breakage by ameding -rt with home-made landmines
does sound like an optimized entertainment strategy...

This type of blowups will not help to go mainline (refereing to 3.12.X here, 
3.4/6/8/10 is a different story).

thx!
hofrat
