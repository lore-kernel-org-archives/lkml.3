Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300Ab3GLTpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:45:00 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:34341 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3GLTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <51E04AB9.1000003@zytor.com>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130712005023.GB31005@thunk.org>
	<20130712025745.GA24086@tuxdriver.com>
	<20130712033430.GA3798@kroah.com>
	<51E03AEE.5010403@zytor.com>
	<20130712172836.GA7627@kroah.com>
	<20130712175718.GA342@thunk.org>
	<51E0480A.2040905@zytor.com>
	<51E04AB9.1000003@zytor.com>
Date: Fri, 12 Jul 2013 12:44:58 -0700
X-Google-Sender-Auth: LhtPJDrROm7XgcwWvIev_fCBUfc
Message-ID: <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:28 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> OK, just read up some more on git notes, and *both* the assumptions I
> had made about git notes were fundamentally wrong.  Not sure how well
> they would scale, though, but stuffing metadata like additional
> Acked-by:, Tested-by: and Cc: stable into notes seems more viable after
> reading the spec.

I really don't want to use git notes for anything that actually gets
distributed.

They can be useful for "local" notes (they can be very powerful for
certain workflows), but they won't be pulled and pushed by me.

                Linus
