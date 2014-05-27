Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaE0OZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:25:54 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:53916 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbaE0OZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:25:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4VACKfhFNXQwje/2dsb2JhbABZgweCRahnAQEBAQEBBQGDPJRMAgIBgQ0XdIIlAQEEATocIwULCAMYLjkeBhOIOgwB1R8XhVWIfQeEQAEDmXIBixeIEIM6Ow
Date: Tue, 27 May 2014 16:25:54 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] lib/debugobjects.c: convert printk to pr_foo()
Message-Id: <20140527162554.c0e15156130eedf712934eea@skynet.be>
In-Reply-To: <20140525034043.GA26647@thin>
References: <1400936768-24897-1-git-send-email-fabf@skynet.be>
	<20140524215322.GA24038@thin>
	<20140525051836.116fe09126f16de8b3955d27@skynet.be>
	<20140525034043.GA26647@thin>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2014 20:40:43 -0700
Josh Triplett <josh@joshtriplett.org> wrote:

> On Sun, May 25, 2014 at 05:18:36AM +0200, Fabian Frederick wrote:
> > On Sat, 24 May 2014 14:53:22 -0700
> > Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> > > On Sat, May 24, 2014 at 03:06:08PM +0200, Fabian Frederick wrote:
> > > > Convert all except KERN_DEBUG
> > > 
> > > Why not KERN_DEBUG?
> > printk(KERN_DEBUG can't be converted to pr_debug the same way as other printk.
> 
> True, but I don't see any obvious reason why that prevents you from
> converting them.  More importantly, though, you should explain for the
> benefit of the changelog.

	There's no documentation yet in mainline for this but in linux-next:
commit 8ce2658fc31bb7

	I can submit one more patch with pr_debug conversion using #define DEBUG
or compilation -DDEBUG

Fabian

> 
> - Josh Triplett
