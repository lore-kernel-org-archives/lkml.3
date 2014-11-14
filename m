Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934869AbaKNBvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:51:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977AbaKNBvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:51:50 -0500
Date: Thu, 13 Nov 2014 17:52:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v17 0/7] MADV_FREE support
Message-Id: <20141113175219.d9290ffe.akpm@linux-foundation.org>
In-Reply-To: <20141113225809.GA8997@bbox>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
	<20141113225809.GA8997@bbox>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 07:58:09 +0900 Minchan Kim <minchan@kernel.org> wrote:

> It seems I have waited your review for a long time.
> What should I do to take your time slot?

I'm being terrible, sorry.

I'll merge the patches into -mm next week so at least they get some
external testing while I get my ass into gear.
