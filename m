Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3EZPAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:00:09 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42186 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3EZPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:00:07 -0400
MIME-Version: 1.0
In-Reply-To: <51A21C63.4010606@gmail.com>
References: <1369298568-20094-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <51A16268.4000401@gmail.com> <51A21C63.4010606@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 26 May 2013 10:59:46 -0400
Message-ID: <CAHGf_=rq7vByQVmVGyFk51q_d=ftpjuMjNXSszcfHWmZMu6jjw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/memory-hotplug: fix lowmem count overflow when
 offline pages
To: Liu Jiang <liuj97@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi KOSAKI,
>         Could you please help to give more information on the background
> about why 32bit platforms with highmem can't support memory hot-removal?

It doesn't impossible. Just nobody did. I was playing these code as a
maintainer a while
and I saw all of patches doesn't handle highmem correctly. But I
didn't refuse because
I know it's not a regression.

> We are trying to enable memory hot-removal on some 32bit platforms with
> highmem, really appreciate your help here!

But, if you guys have a strong motivation, it's a very good news. I
have no objection not to mark it broken and accept your contributions.
