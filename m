Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbbAFUj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:39:28 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:54819 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbAFUj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:39:27 -0500
Date: Tue, 6 Jan 2015 22:39:18 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <balbi@ti.com>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106203918.GI30544@fuloong-minipc.musicnaut.iki.fi>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106175115.GA19487@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 06, 2015 at 06:51:15PM +0100, Pavel Machek wrote:
> On Tue 2015-01-06 11:25:45, Felipe Balbi wrote:
> > On Tue, Jan 06, 2015 at 06:04:33PM +0100, Pavel Machek wrote:
> > > In 3.18, sound is nice and clear.
> > > 
> > > In 3.19, sound is unusable. It produces nasty tone when it should be
> > > quiet, and there's at least as much noise as is sound.
> > > 
> > > Unfortunately, list of mixers also changed (and there's cca 120
> > > settings), but a) it does not work with the old list and b) nothing I
> > > could figure out did make the sound usable. Some setting resulted in
> > > even more noise.
> > > 
> > > Any idea what could have caused it?
> > 
> > $ git bisect start
> > $ git bisect good v3.18
> > $ git bisect bad
> > 
> > that'll help find what caused it.
> 
> Telling someone to do hard and time consuming job that probably will
> not succeed, instead of actually providing help. Very very funny.

No, that was actually really a good advice. You should try to bisect it.
It doesn't take that long (I assume you are cross-compiling instead
of doing native builds), also Linux maintainers are generally doing
a very good job ensuring the tree is bisectable.

I would do it myself, but so far I never have set up my N900 to play
any audio and I don't have any reference points between "good" or "bad".

A.
