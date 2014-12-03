Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaLCEvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:51:48 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:60200 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaLCEvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:51:46 -0500
Message-ID: <547e96e0.d3518c0a.41af.7747@mx.google.com>
Date: Wed, 3 Dec 2014 02:51:39 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
	<547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
	<CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 20:14:52 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> What is *really* suspicious is a series of "git bisect good" with no
> "bad"s anywhere. Which is exactly what we see at the end of the
> bisect.
> 
> So might I ask you to try starting from this point again (this is why
> the bisect log is so useful - no need to retest the above part, you
> can just mindlessly do that sequence by hand without testing), and
> starting with this commit:
> 
> > # good: [47dfe4037e37b2843055ea3feccf1c335ea23a9c] Merge branch
> > 'for-3.17' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup git bisect
> > good 47dfe4037e37b2843055ea3feccf1c335ea23a9c

> Of course, bugs can come in from anywhere, so it *could* be the
> tracing one, and it *could* be the merge commit, but my gut just
> screams that you probably missed one bad kernel, and marked it good.
> And it's really that very first one (ie commit
> 47dfe4037e37b2843055ea3feccf1c335ea23a9c) that contains most of the
> actually suspect code, so I'd really like you to re-test that one a
> lot before you call it "good" again.
> 
> Humor me.
> 
> I added Tejun to the Cc, just because I wanted to give him a heads-up
> that I am tentatively starting to blame him in my dark little mind..

	:)

	I understand Linus. I'll try the 47dfe4037 commit you
suggested harder and I'll return tomorrow.  

-- 
Linux 3.16.0-00409-gb8c0aa4: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
