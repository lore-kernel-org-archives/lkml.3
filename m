Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3CYMXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:23:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab3CYMXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:23:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1364109934-7851-25-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-25-git-send-email-jiang.liu@huawei.com> <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH v2, part4 16/39] mm/frv: prepare for removing num_physpages and simplify mem_init()
Date: Mon, 25 Mar 2013 12:21:28 +0000
Message-ID: <7011.1364214088@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Does your patch emailer have a bug in it?  Or did you submit a second batch 1s
after the first, but with different patch numbering?  Patches 16 & 17 and 24 &
25 and 25 & 26 look the same (I have two different copies of patch 25).

David
