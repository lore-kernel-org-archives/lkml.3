Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3LFSvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:51:39 -0500
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:44145 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab3LFSvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:51:38 -0500
Date: Fri, 6 Dec 2013 18:51:36 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm/migrate: correct return value of
 migrate_pages()
In-Reply-To: <1386355046-jja39cg0-mutt-n-horiguchi@ah.jp.nec.com>
Message-ID: <00000142c9403016-a312eac7-8ca7-4f93-a61d-5b8eccbcb9db-000000@email.amazonses.com>
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com> <52A1E248.1000204@suse.cz> <1386355046-jja39cg0-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.06-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013, Naoya Horiguchi wrote:

> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Fri, 6 Dec 2013 13:08:15 -0500
> Subject: [PATCH] migrate: add comment about permanent failure path
>
> Let's add a comment about where the failed page goes to, which makes
> code more readable.

Acked-by: Christoph Lameter <cl@linux.com>
