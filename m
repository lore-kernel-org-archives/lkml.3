Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3EHGzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:55:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:56992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3EHGzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:55:10 -0400
Message-ID: <1367996104.8279.5.camel@jlt4.sipsolutions.net>
Subject: Re: Dropping non supported kernels for kernel backports ?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 08 May 2013 08:55:04 +0200
In-Reply-To: <CAB=NE6Wy0dp51wDxKzo74Kz=2F-MQjOnARS1r-z3v+LrOwhn-Q@mail.gmail.com> (sfid-20130508_015436_904346_B7B59A0B)
References: <CAB=NE6Wy0dp51wDxKzo74Kz=2F-MQjOnARS1r-z3v+LrOwhn-Q@mail.gmail.com>
	 (sfid-20130508_015436_904346_B7B59A0B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 16:53 -0700, Luis R. Rodriguez wrote:
> Today the backports project provides support to backport down to
> 2.6.24 for some subsystems. While this is good for users in practice
> for development and maintenance this is quite a bit of overhead. Apart
> from older kernels there are also gaps in between stable releases that
> are not supported. For example 3.8 and 3.4 are supported but anything
> in between is not (3.5, 3.6, 3.7), but we still do support them on the
> backports project. At times this may mean a stable fix may get
> propagated onto a the linux-3.4.y branch but obviously not the the
> linux-3.5.y branch. If backporting expressing this becomes a bit
> complex and we have dealt with it. In short, its a pain.
> 
> I'd like to see what folks thought if we went ahead and *only*
> supported kernels listed on kernel.org as supported. This would help
> with the Linux kernel maintainer effort by also persuading users to
> upgrade to stable releases as well as educating around this.
> 
> If v3.10 backported releases are too soon to do this I propose we
> seriously consider it for v3.11 releases. Any thoughts?

I'm sure I'd still have to support other kernels random customers might
be on (customers, they don't always do the smart thing ;-) ). I could do
that myself of course, but then where would I stick the support patches?

Maybe we could do a compromise and drop support for no longer supported
kernels, but only a few years later? If we put the cutoff at 3 years now
we'd drop everything before 2.6.34, for example.

johannes

