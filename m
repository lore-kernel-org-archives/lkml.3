Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaI1WxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 18:53:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14559 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaI1WxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 18:53:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18l9lRQS0a519fuz9G8eixS2uOOTJFlzNE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 91D875EF945
Date: Sun, 28 Sep 2014 18:53:02 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eric Rost <eric.rost@mybabylon.net>, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed Conditional white space problems
Message-ID: <20140928225302.GE23926@titan.lakedaemon.net>
References: <20140928215426.GA10384@localhost>
 <20140928220101.GA25770@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928220101.GA25770@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 06:01:01PM -0400, Greg KH wrote:
> On Sun, Sep 28, 2014 at 04:54:26PM -0500, Eric Rost wrote:
> > My first patch, resent to appropriate multiple addresses!
> 
> That's great, but it doesn't belong here in the body of the changelog :)
> 
> > This patch fixes the following checkpatch.pl Warnings:
> > 
> > WARNING: suspect code indent for conditional statements (16, 16)
> > +               for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
> > [...]
> > +               {
> > 
> > WARNING: suspect code indent for conditional statements (16, 16)
> > +               for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
> > [...]
> > +               {
> 
> Your subject should give a clue as to what part of the kernel it
> modifies, for this patch, it might look like:
> 	staging: skein: fixed conditional...
> 
> Care to fix that up and resend?

With Greg's comments addressed,

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
