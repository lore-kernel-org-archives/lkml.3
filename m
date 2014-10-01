Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaJASNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:13:38 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:38377 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaJASNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <20141001180510.GA28540@cloud>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
 <542B4DA3.5080105@gmail.com> <542B519B.6010001@landley.net>
 <542B5E44.40303@gmail.com> <542B7200.6030902@landley.net> <CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>
 <20141001180510.GA28540@cloud>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 Oct 2014 11:13:14 -0700
Message-ID: <CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rob Landley <rob@landley.net>, frowand.list@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 11:05 AM,  <josh@joshtriplett.org> wrote:
> On Tue, Sep 30, 2014 at 09:53:56PM -0700, Andy Lutomirski wrote:
>> I significantly prefer default N.  Scripts that play with init= really
>> don't want the fallback, and I can imagine contexts in which it could
>> be a security problem.
>
> While I certainly would prefer the non-fallback behavior for init as
> well, standard kernel practice has typically been to use "default y" for
> previously built-in features that become configurable.  And I'd
> certainly prefer a compile-time configuration option like this (even
> with default y) over a "strictinit" kernel command-line option.
>

Fair enough.

So: "default y" for a release or two, then switch the default?  Having
default y will annoy virtme, though it's not the end of the world.
Virtme is intended to work with more-or-less-normal kernels.

--Andy
