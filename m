Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaJAWme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:42:34 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38836 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaJAWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:42:33 -0400
Date: Wed, 1 Oct 2014 15:42:28 -0700
From: josh@joshtriplett.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Rob Landley <rob@landley.net>, frowand.list@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
Message-ID: <20141001224228.GA30343@cloud>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
 <542B4DA3.5080105@gmail.com>
 <542B519B.6010001@landley.net>
 <542B5E44.40303@gmail.com>
 <542B7200.6030902@landley.net>
 <CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>
 <20141001180510.GA28540@cloud>
 <CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 11:13:14AM -0700, Andy Lutomirski wrote:
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
> 
> Fair enough.
> 
> So: "default y" for a release or two, then switch the default?

Default y for a few releases, get it on the radar of various
distributions so they make an explicit decision about it, then consider
changing the upstream default.

- Josh Triplett
