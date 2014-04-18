Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaDRSyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:54:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRSyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:54:40 -0400
Date: Fri, 18 Apr 2014 11:54:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-Id: <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
In-Reply-To: <20140326192815.GC18118@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-9-git-send-email-jack@suse.cz>
	<20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
	<20140326192815.GC18118@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 20:28:15 +0100 Jan Kara <jack@suse.cz> wrote:

> > All the afflicted consoles are serial, all go via the uart layer as far
> > as I can see.
> > 
> > The uart layer has a queue mechanism that could be used
>   I'm sorry, I don't follow here - what can the uart queueing be used for?

Alan, I'm desperate to avoid adding all this complexity to core printk
code to solve such a rare problem.  It'd be great if you could flesh out
any alternative ideas please.
