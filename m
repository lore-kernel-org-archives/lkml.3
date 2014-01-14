Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaANJnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:43:07 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:41647 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaANJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:43:01 -0500
Date: Tue, 14 Jan 2014 10:42:53 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, qiuxishi@huawei.com,
        dhowells@redhat.com, daeseok.youn@gmail.com, liuj97@gmail.com,
        yinghai@kernel.org, zhangyanfei@cn.fujitsu.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH V3 2/2] mm/memblock: Add support for excluded memory
 areas
Message-ID: <20140114104253.54ea0470@lilie>
In-Reply-To: <20140113163620.ade5ee9171c5f443a227f8af@linux-foundation.org>
References: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1389618217-48166-3-git-send-email-phacht@linux.vnet.ibm.com>
	<20140113163620.ade5ee9171c5f443a227f8af@linux-foundation.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011409-1948-0000-0000-00000776F5C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mon, 13 Jan 2014 16:36:20 -0800
schrieb Andrew Morton <akpm@linux-foundation.org>:

> Patch is big.  I'll toss this in for some testing but it does look too
> large and late for 3.14.  How will this affect your s390 development?

It is needed for s390 bootmem -> memblock transition. The s390 dump
mechanisms cannot be switched to memblock (from using something s390
specific called memory_chunk) without the nomap list.
I'm also working on another enhancement on s390 that will rely on a
clean transition to memblock.

I have written and tested the stuff on top of our local development
tree. And then realised that it does not fit the linux-next tree. So I
converted it to fit linux-next and posted it. Have to maintain two
versions now. 


