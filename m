Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaIWVah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:30:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaIWVag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:30:36 -0400
Date: Tue, 23 Sep 2014 14:30:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Layton <jeff.layton@primarydata.com>
Subject: Re: [PATCH 1/4] SCHED: add some "wait..on_bit...timeout()"
 interfaces.
Message-Id: <20140923143034.4adbbbfd12174baaab1a1ee4@linux-foundation.org>
In-Reply-To: <20140923121052.55dcb4f5@notabene.brown>
References: <20140916051911.22257.24658.stgit@notabene.brown>
	<20140916053134.22257.28841.stgit@notabene.brown>
	<20140918144222.GP2840@worktop.localdomain>
	<20140923121052.55dcb4f5@notabene.brown>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 12:10:52 +1000 NeilBrown <neilb@suse.de> wrote:

> Now I just need an Ack from akpm for the mm bits (please...)

Ack
