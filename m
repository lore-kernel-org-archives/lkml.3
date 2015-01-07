Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbbAGWnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:43:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbbAGWnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:43:18 -0500
Date: Wed, 7 Jan 2015 14:43:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: livepatching tree for linux-next
Message-Id: <20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
In-Reply-To: <20141226155613.36dd95b9@canb.auug.org.au>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
	<20141223094607.GA16445@infradead.org>
	<20141223151056.GA4789@treble.redhat.com>
	<20141226155613.36dd95b9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2014 15:56:13 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> OK, I have added this from today

My x86_64 allmodconfig broke.

In file included from include/linux/livepatch.h:29,
                 from kernel/livepatch/core.c:30:
./arch/x86/include/asm/livepatch.h:29:2: error: #error Your compiler must support -mfentry for live patching to work

