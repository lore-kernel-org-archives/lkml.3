Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab3CGTYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:24:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab3CGTYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:24:40 -0500
Date: Thu, 7 Mar 2013 14:10:05 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
Message-ID: <20130307191005.GH13719@hansolo.jdub.homelinux.org>
References: <20130307185642.GF13719@hansolo.jdub.homelinux.org>
 <5138E56B.6090308@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5138E56B.6090308@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:07:23PM +0100, Jiri Slaby wrote:
> On 03/07/2013 07:56 PM, Josh Boyer wrote:
> > commit 835d844d1a28efba81d5aca7385e24c29d3a6db2
> > Author: Sean Young <sean@mess.org>
> > Date:   Fri Sep 7 19:06:23 2012 +0100
> > 
> >     8250_pnp: do pnp probe before legacy probe
> > 
> > but that is simply moving code around.
> 
> Hi, not quite. Does it still happen when you revert that one on the top
> of 3.[789]*?

That was going to be my first attempt.  I'll let you know how it goes.

> > I ran the same test on a 3.9-rc1 kernel and it isn't being picked up
> > there either.  Before I go off and do a bisect to track this down, has
> > anyone else seen or heard of this no longer working?
> 
> I haven't heard of that yet.

Oh fun!  New bugs to fix.  I always like it when I'm not wasting my time
chasing something that was already solved ;).

josh
