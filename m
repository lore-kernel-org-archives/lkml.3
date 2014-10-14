Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaJNVAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:00:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaJNVAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:00:53 -0400
Date: Tue, 14 Oct 2014 14:00:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Triplett <josh@joshtriplett.org>, Rob Landley <rob@landley.net>,
        frowand.list@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
Message-Id: <20141014140052.2f114c158ffe6cd953020f1c@linux-foundation.org>
In-Reply-To: <CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
	<542B4DA3.5080105@gmail.com>
	<542B519B.6010001@landley.net>
	<542B5E44.40303@gmail.com>
	<542B7200.6030902@landley.net>
	<CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>
	<20141001180510.GA28540@cloud>
	<CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014 11:13:14 -0700 Andy Lutomirski <luto@amacapital.net> wrote:

> On Wed, Oct 1, 2014 at 11:05 AM,  <josh@joshtriplett.org> wrote:
> > On Tue, Sep 30, 2014 at 09:53:56PM -0700, Andy Lutomirski wrote:
> >> I significantly prefer default N.  Scripts that play with init= really
> >> don't want the fallback, and I can imagine contexts in which it could
> >> be a security problem.
> >
> > While I certainly would prefer the non-fallback behavior for init as
> > well, standard kernel practice has typically been to use "default y" for
> > previously built-in features that become configurable.  And I'd
> > certainly prefer a compile-time configuration option like this (even
> > with default y) over a "strictinit" kernel command-line option.
> >
> 
> Fair enough.
> 
> So: "default y" for a release or two, then switch the default?  Having
> default y will annoy virtme, though it's not the end of the world.
> Virtme is intended to work with more-or-less-normal kernels.
> 

Adding another Kconfig option is tiresome.  What was wrong with strictinit=?
