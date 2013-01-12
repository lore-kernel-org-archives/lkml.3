Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3ALAmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:42:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:39608 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab3ALAms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:42:48 -0500
Date: Fri, 11 Jan 2013 16:42:44 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 10 (staging/sb105x)
Message-ID: <20130112004244.GA2578@kroah.com>
References: <20130110143241.041ef77011ef7b1f68ae5c61@canb.auug.org.au>
 <50EF11B2.9090505@infradead.org>
 <1357851057.5141.16.camel@gandalf.local.home>
 <50EF3B6A.70704@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EF3B6A.70704@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 02:06:34PM -0800, Randy Dunlap wrote:
> On 01/10/13 12:50, Steven Rostedt wrote:
> > On Thu, 2013-01-10 at 11:08 -0800, Randy Dunlap wrote:
> >> On 01/09/13 19:32, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20130109:
> >>>
> >>
> >> on x86_64, when CONFIG_PARPORT_PC is not enabled:
> >>
> >> drivers/built-in.o: In function `multi_init':
> >> sb_pci_mp.c:(.init.text+0x15684): undefined reference to `parport_pc_probe_port'
> >>
> >>
> >> Full randconfig file is attached.
> > 
> > Ug, so https://lkml.org/lkml/2012/12/14/250 should have been
> > CONFIG_PARPORT_PC and not just PARPORT :-P
> > 
> > Can you try this patch:
> 
> That's good.  Thanks.
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Steven, care to send me a patch that I can apply?

thanks,

greg k-h
