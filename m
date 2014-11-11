Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaKKWXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:23:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaKKWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:23:46 -0500
Date: Tue, 11 Nov 2014 14:23:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: kamezawa.hiroyu@jp.fujitsu.com, "'Minchan Kim'" <minchan@kernel.org>,
        mgorman@suse.de, mina86@mina86.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH 1/2] mm: page_isolation: check pfn validity before
 access
Message-Id: <20141111142344.b4eb11c6e3c240d345fdd995@linux-foundation.org>
In-Reply-To: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
References: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2014 16:08:02 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:

> In the undo path of start_isolate_page_range(), we need to check
> the pfn validity before access its page, or it will trigger an
> addressing exception if there is hole in the zone.
> 

There is not enough information in the chagnelog for me to decide how
to handle the patch.  3.19?  3.18? 3.18+stable?

When fixing bugs, please remember to fully explain the end-user impact
of the bug.  Under what circumstances does it occur?


