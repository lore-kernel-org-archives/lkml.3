Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbaJ3IB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:01:27 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:42774 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaJ3IB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:01:26 -0400
Message-ID: <1414656079.1823.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] tiny: reverse logic for DISABLE_DEV_COREDUMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 30 Oct 2014 09:01:19 +0100
In-Reply-To: <20141020221800.GB2101@kroah.com>
References: <20141016133658.GP5930@redhat.com> <20141016134430.GB7664@thin>
	 <20141016154949.GR5930@redhat.com>
	 <1413798151.10246.10.camel@jlt4.sipsolutions.net>
	 <20141020115511.GA28133@thin> <20141020221800.GB2101@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 06:18 +0800, Greg Kroah-Hartman wrote:

> > I've added this to the tiny/reverse-dev-coredump branch of my
> > tinification tree at
> > https://git.kernel.org/cgit/linux/kernel/git/josh/linux.git/ , with
> > Johannes' review, and I'll push it upstream during the 3.19 merge
> > window.
> 
> I'll take it through the same tree this original came in and will get it
> into 3.18 so we don't confuse anyone with an odd config option.

I don't know how far this commit made it, but looking at it again now I
think the new option should probably be called "Allow device coredump"
rather than "Enable device coredump" since it doesn't actually enable it
if no drivers want it.

Should I send another patch on top?

johannes

