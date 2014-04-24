Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbaDXOA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:00:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57222 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaDXOA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:00:56 -0400
Date: Thu, 24 Apr 2014 15:00:43 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140424150043.13587920@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.LRH.2.00.1404232341100.1491@twin.jikos.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-9-git-send-email-jack@suse.cz>
	<20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
	<20140326192815.GC18118@quack.suse.cz>
	<20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
	<20140422112259.5f106a44@alan.etchedpixels.co.uk>
	<20140423110847.GB17824@quack.suse.cz>
	<20140423111750.88ad799bb271a1fe0bed119f@linux-foundation.org>
	<20140423221609.0d3b536f@alan.etchedpixels.co.uk>
	<alpine.LRH.2.00.1404232341100.1491@twin.jikos.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 23:41:59 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 23 Apr 2014, One Thousand Gnomes wrote:
> 
> > Given this all only affects huge boxes and the only fix we have right 
> > now is hideously ugly I'd rather it stayed in the vendor hacks to their 
> > trees, until someone is inspired to sort it properly.
> 
> I have to say I am rather disappointed by this statement, indirectly 
> implying that vanilla kernel doesn't care about booting properly on huge 
> boxes.

You read what you like into it, but don't imply that I don't care about
big boxes. It's a corner case. We shouldn't muck the rest of the system
up by botchfixing for a corner case. It's not a regression.

Find a clean fix for it and it's different, but the clean fix seems to be
involve getting a chunk of the continuing tty into tty_port work done.

Alan
