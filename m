Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3EMJm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:42:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab3EMJm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:42:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <15961.1368438077@warthog.procyon.org.uk>
References: <15961.1368438077@warthog.procyon.org.uk> <1368293689-16410-3-git-send-email-jiang.liu@huawei.com> <1368293689-16410-1-git-send-email-jiang.liu@huawei.com>
Cc: dhowells@redhat.com, Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v6, part3 02/16] mm: enhance free_reserved_area() to support poisoning memory with zero
Date: Mon, 13 May 2013 10:42:37 +0100
Message-ID: <15994.1368438157@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Jiang Liu <liuj97@gmail.com> wrote:
> 
> > +	free_reserved_area((void *)start, (void *)end, -1, "initrd");
> 
> Do you mean -1 or ULONG_MAX?

No matter...  It's a poison value, not an address.

David
