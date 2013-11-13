Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab3KMTFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:05:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:41083 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889Ab3KMTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:05:30 -0500
Date: Wed, 13 Nov 2013 14:05:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] rcu: Make struct rcu_head searchable
Message-ID: <20131113140528.7680d1df@gandalf.local.home>
In-Reply-To: <20131113105705.c3fed1c5.akpm@linux-foundation.org>
References: <20131113120225.3aacae13@gandalf.local.home>
	<20131113171205.GG4138@linux.vnet.ibm.com>
	<20131113131044.677cdc74@gandalf.local.home>
	<20131113105705.c3fed1c5.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 10:57:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:


> That irritates me too.  Fortunately I just invented
> 
> (grep "#define" tags && grep -v "#define" tags) > tags.new

Unfortunately, TAGS doesn't work that way. Hmm, I could whip up a perl
script to do it for me though.

-- Steve
