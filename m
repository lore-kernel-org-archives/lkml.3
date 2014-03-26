Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaCZRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:16:57 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50611 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbaCZRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:16:55 -0400
Date: Wed, 26 Mar 2014 17:16:41 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6/8] printk: Start printing handover kthreads on demand
Message-ID: <20140326171641.0e117018@alan.etchedpixels.co.uk>
In-Reply-To: <1395770101-24534-7-git-send-email-jack@suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-7-git-send-email-jack@suse.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014 18:54:59 +0100
Jan Kara <jack@suse.cz> wrote:

> Start kthreads for handing over printing only when printk.offload_chars
> is set to value > 0 (i.e., when print offloading gets enabled).

The original set it was suggested that having all these threads around
that 99.99999% of users don't need was a waste and why not start them
when needed. Also I asked why you couldn't just schedule_work the jobs
onto CPUs instead.

I don't recall seeing a reply to that - and it doesn't appear fixed here ?

Alan
