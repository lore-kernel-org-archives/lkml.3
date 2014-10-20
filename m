Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaJTV2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:28:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJTV2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:28:36 -0400
Date: Mon, 20 Oct 2014 14:28:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Frank Rowand <frowand.list@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
Message-Id: <20141020142836.fcea4aa8dd7bb5cfe9ede423@linux-foundation.org>
In-Reply-To: <20141020210155.GD29486@jtriplet-mobl1>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
	<542B4DA3.5080105@gmail.com>
	<542B519B.6010001@landley.net>
	<542B5E44.40303@gmail.com>
	<542B7200.6030902@landley.net>
	<CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>
	<20141001180510.GA28540@cloud>
	<CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
	<20141014140052.2f114c158ffe6cd953020f1c@linux-foundation.org>
	<CALCETrVg_rFmSCSnyztRtvANQLd9k_G+bU8FiQB_5O5ecUd99w@mail.gmail.com>
	<20141020210155.GD29486@jtriplet-mobl1>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 14:01:55 -0700 Josh Triplett <josh@joshtriplett.org> wrote:

> > IOW, the no-fallback behavior is easy to implement, easy to
> > understand, and has extremely predictable behavior.  The fallback
> > behavior is more user friendly if you consider having a chance of
> > booting to something useful if you typo your init= option (but also a
> > chance of booting to something actively undesirable).
> 
> Here's an alternative proposal: how about we change the default
> *without* a Kconfig option, see if anyone screams, and if they do, we
> add that code back in under a Kconfig option as in your current patch?
> 
> Would that make your Kconfig senses stop tingling, Andrew? :)

Mumble.  I suppose we can run with it as-is: at least the config option
is there to allow people to repair any damage easily.

However we don't have any way of remembering to remove the config
option later coz someone removed feature-removal-schedule.txt, which
was a useful feature.
