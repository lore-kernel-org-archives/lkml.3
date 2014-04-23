Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaDWJap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:30:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaDWJal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:30:41 -0400
Date: Wed, 23 Apr 2014 11:30:37 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140423093037.GA17824@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
 <1395770101-24534-9-git-send-email-jack@suse.cz>
 <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
 <20140326192815.GC18118@quack.suse.cz>
 <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-04-14 11:54:38, Andrew Morton wrote:
> On Wed, 26 Mar 2014 20:28:15 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > > All the afflicted consoles are serial, all go via the uart layer as far
> > > as I can see.
> > > 
> > > The uart layer has a queue mechanism that could be used
> >   I'm sorry, I don't follow here - what can the uart queueing be used for?
> 
> Alan, I'm desperate to avoid adding all this complexity to core printk
> code to solve such a rare problem.  It'd be great if you could flesh out
> any alternative ideas please.
  OK, Andrew, can you please queue at least patches 1-4 in the series?
Noone is objecting to those, they make sense on their own, and it makes life
somewhat simpler for me. Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
