Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab3LIQch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:32:37 -0500
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:43624 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932633Ab3LIQcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:32:36 -0500
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2013 11:32:36 EST
Date: Mon, 9 Dec 2013 16:20:13 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 6/7] mm/migrate: remove unused function,
 fail_migrate_page()
In-Reply-To: <1386580248-22431-7-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000142d828aafc-37d556c5-558d-4c78-86bf-006921ad6dae-000000@email.amazonses.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com> <1386580248-22431-7-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.09-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Joonsoo Kim wrote:

> fail_migrate_page() isn't used anywhere, so remove it.

Acked-by: Christoph Lameter <cl@linux.com>
