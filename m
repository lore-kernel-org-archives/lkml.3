Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937579Ab3DJXAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:00:47 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50540 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937489Ab3DJXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:00:27 -0400
Date: Wed, 10 Apr 2013 16:00:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [ 41/64] spinlocks and preemption points need to be at least
 compiler barriers
Message-ID: <20130410230025.GA4750@kroah.com>
References: <20130410224333.114387235@linuxfoundation.org>
 <20130410224342.778004071@linuxfoundation.org>
 <CA+55aFzVuENsvQM1huNkJRcvcWow1xcVeaGkbYEd-JonJ9HqEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzVuENsvQM1huNkJRcvcWow1xcVeaGkbYEd-JonJ9HqEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 03:54:44PM -0700, Linus Torvalds wrote:
> On Wed, Apr 10, 2013 at 3:46 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Note for stable: use discretion when/if applying this.  As mentioned,
> > this bug may never have actually bitten anybody, and gcc may never have
> > done the required code motion for it to possibly ever trigger in
> > practice.
> 
> No objections, I just wanted to make sure the stable people had
> noticed this message to them...

Yeah, I saw it, and it looks like a valid thing to apply.

thanks,

greg k-h
