Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaFDXRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:17:01 -0400
Received: from longford.logfs.org ([213.229.74.203]:43474 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaFDXQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:16:59 -0400
Date: Wed, 4 Jun 2014 19:15:06 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-ID: <20140604231506.GA31276@logfs.org>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <20140424005247.GA17713@logfs.org>
 <20140424194024.GA25446@logfs.org>
 <20140428234039.GC6358@logfs.org>
 <20140428172219.4be61cf7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140428172219.4be61cf7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 April 2014 17:22:19 -0700, Andrew Morton wrote:
> On Mon, 28 Apr 2014 19:40:39 -0400 J__rn Engel <joern@logfs.org> wrote:
> > On Thu, 24 April 2014 15:40:24 -0400, J__rn Engel wrote:
> > > On Wed, 23 April 2014 20:52:47 -0400, J__rn Engel wrote:
> > > > 
> > > > I use the patch below for some time now.  While it doesn't avoid the
> > > > log pollution in the first place, it lessens the impact somewhat.
> > > 
> > > Added a config option and ported it to current -linus.  Andrew, would
> > > you take this patch?
> > 
> > Andrew?  Did you dislike this patch for some reason or just miss it in
> > the thread?
> 
> Neither ;) I try to respond in some way to all patches unless I think it's clear
> to the originator why I took no action.  And I think I'm pretty good at
> not losing stuff.
> 
> otoh, it has only been four days, three of which I spent offline...

Ping.  It is closer to 40 days now.  Can I fault this patch back into
your memory?

Jörn

--
Good warriors cause others to come to them and do not go to others.
-- Sun Tzu
