Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3CYV0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:26:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758631Ab3CYV0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:26:32 -0400
Date: Mon, 25 Mar 2013 14:26:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Russ Anderson <rja@sgi.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-Id: <20130325142630.faf41b11416c2e4ac3d61550@linux-foundation.org>
In-Reply-To: <20130321180321.GB4185@gmail.com>
References: <20130318155619.GA18828@sgi.com>
	<20130321105516.GC18484@gmail.com>
	<20130321123505.GA6051@dhcp22.suse.cz>
	<20130321180321.GB4185@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013 19:03:21 +0100 Ingo Molnar <mingo@kernel.org> wrote:

> > IMO the local scope is more obvious as this is and should only be used 
> > for caching purposes.
> 
> It's a pattern we actively avoid in kernel code.

On the contrary, I always encourage people to move the static
definitions into function scope if possible.  So the reader can see the
identifier's scope without having to search the whole file. 
Unnecessarily giving the identifier file-scope seems weird.

