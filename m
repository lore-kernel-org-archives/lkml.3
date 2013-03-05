Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3CEAMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:12:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43028 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab3CEAML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:12:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130304102859.GA23311@dcvr.yhbt.net>
References: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
 <1361820175.6781.13.camel@edumazet-glaptop> <CAOPLpQe5SfdWYv5QD4Fu90PXyS7SrSN_5Gntk2x5D5ea8ke64g@mail.gmail.com>
 <20130304102859.GA23311@dcvr.yhbt.net>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 4 Mar 2013 19:11:49 -0500
Message-ID: <CAOPLpQeJB_oEmvgV-DSoZ=aYjD8+8WdkkupBimufqFfz_hrquQ@mail.gmail.com>
Subject: Re: sendfile and EAGAIN
To: Eric Wong <normalperson@yhbt.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 5:28 AM, Eric Wong <normalperson@yhbt.net> wrote:
> If you manage to reproduce it, can you pass an offset to sendfile() and
> see if the offset changed when you get EAGAIN?

I did that and didn't see the offset to change.


> Also, which kernel version are you using?  Perhaps it's triggered
> by memory pressure.

That was with the RHEL6.2 kernel.  I don't have the details as to what
patches are included on top of 2.6.32...
