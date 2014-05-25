Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaEYDky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 23:40:54 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38866 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaEYDkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 23:40:53 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 24 May 2014 20:40:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] lib/debugobjects.c: convert printk to pr_foo()
Message-ID: <20140525034043.GA26647@thin>
References: <1400936768-24897-1-git-send-email-fabf@skynet.be>
 <20140524215322.GA24038@thin>
 <20140525051836.116fe09126f16de8b3955d27@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140525051836.116fe09126f16de8b3955d27@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 05:18:36AM +0200, Fabian Frederick wrote:
> On Sat, 24 May 2014 14:53:22 -0700
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > On Sat, May 24, 2014 at 03:06:08PM +0200, Fabian Frederick wrote:
> > > Convert all except KERN_DEBUG
> > 
> > Why not KERN_DEBUG?
> printk(KERN_DEBUG can't be converted to pr_debug the same way as other printk.

True, but I don't see any obvious reason why that prevents you from
converting them.  More importantly, though, you should explain for the
benefit of the changelog.

- Josh Triplett
