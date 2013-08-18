Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3HRUu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:50:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3HRUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:50:25 -0400
Date: Sun, 18 Aug 2013 13:52:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/12] 3.0.92-stable review
Message-ID: <20130818205210.GA32389@kroah.com>
References: <20130818202949.875887601@linuxfoundation.org>
 <CAMuHMdUjM8oQLcbLJ+Zkh8=5Hy=vnY6ogwFRANxSGAxCjxVd2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUjM8oQLcbLJ+Zkh8=5Hy=vnY6ogwFRANxSGAxCjxVd2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 10:37:01PM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Sun, Aug 18, 2013 at 10:30 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 3.0.92 release.
> 
> Please also include
> 
> commit ea077b1b96e073eac5c3c5590529e964767fc5f7
> Author: Andreas Schwab <schwab@linux-m68k.org>
> Date:   Fri Aug 9 15:14:08 2013 +0200
> 
>     m68k: Truncate base in do_div()
> 
> While the crash mentioned in that commit doesn't happen in 3.2 and earlier,
> there are a few other places in the kernel that call do_div() with a
> 64-bit divisor,
> causing unexpected behavior.

I've added this and put out a 3.0.92-rc2 kernel patch, thanks.

And yes, the changelog comments are truncated as well, I'll look into
fixing that later...


greg k-h
