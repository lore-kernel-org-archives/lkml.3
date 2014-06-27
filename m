Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaF0ESR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:18:17 -0400
Received: from 1wt.eu ([62.212.114.60]:44795 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaF0ESQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:18:16 -0400
Date: Fri, 27 Jun 2014 06:17:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.15.2
Message-ID: <20140627041759.GC12884@1wt.eu>
References: <20140626192657.GA24804@kroah.com> <CA+5PVA5-KVc3FnwB6qcj+f22Sh4vuMydE_kHD=5mwMFpiVJ+DQ@mail.gmail.com> <CAKbGBLj+F3yTAg8vPJqHeVvvoH0e6KpC2hH3fxuOu24T8XOhuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKbGBLj+F3yTAg8vPJqHeVvvoH0e6KpC2hH3fxuOu24T8XOhuw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 08:52:10PM -0700, Steven Noonan wrote:
> On Thu, Jun 26, 2014 at 5:23 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > On Thu, Jun 26, 2014 at 3:26 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> I'm announcing the release of the 3.15.2 kernel.
> >>
> >> All users of the 3.15 kernel series must upgrade.
> >>
> >> The updated 3.15.y git tree can be found at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.15.y
> >> and can be browsed at the normal kernel.org git web browser:
> >>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> >
> > Is the patch for this stuck somewhere on kernel.org?  I see
> > patch-3.14.9.xz, but patch-3.15.2.xz is missing on both the kernel.org
> > front page and the 3.x http directory where we'd normally find it.
> >
> 
> Indeed, the patch for 3.10.45 is also missing.

Both are there now :

  https://www.kernel.org/pub/linux/kernel/v3.x/patch-3.15.2.xz
  https://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.45.xz

Willy

