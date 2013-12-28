Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3L1Eds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 23:33:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63081 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab3L1Edq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 23:33:46 -0500
Message-ID: <1388205218.5387.97.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
From: Mike Galbraith <bitbucket@online.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 28 Dec 2013 05:33:38 +0100
In-Reply-To: <1388201449.5387.70.camel@marge.simpson.net>
References: <20131223225017.GA8623@linutronix.de>
	 <20131227200024.GA19505@opentech.at>
	 <1388201449.5387.70.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:aqvALcJnofHIUvpDJ9ZcHOtusNmbViLSBW0mgDG7JC+
 viRc7C1TLG13XTPdpkP1+ifdYptNKjIboodwlY3xkZbXrJHPvF
 lIYAOgSCnDjc0syQJFbbjDW/bwDrRe+zGIMcCWJ5ygbYSPmQSv
 b4pfdI+BKHi9+YoTECLBgPwaqH3uR6Ym+Rl3inMmd3mU2HDR73
 lV+jr9ZKR25uLpUjUsSxU2tus5EDFC2sxeGNOb61vHgDv2LEoP
 305gBVxqUMhLkcflgx31cXdv0y4WwkgW+LNdXahpja7IWYZzwF
 GjwQjr8/e1bkcsFsml48NGOFuKYlrt3Q/6kEB0umxg5288TLFV
 w38yIlySwAMr/hRH3+xELFvx2mXZWTNAYUqwPxTbZ+jiZDe5XI
 H1O1jObVrqpPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-28 at 04:30 +0100, Mike Galbraith wrote:

> Watchdog barked at two such spots..

btw, lockdep doesn't grumble about that (didn't stare at annotation,
don't speak lockdep well).  I fixed it up to not take it's toys and go
home in a snit at boot (rt_mutex debug offends it methinks), but it
didn't gripe.

