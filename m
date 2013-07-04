Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3GDLl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:41:57 -0400
Received: from kanga.kvack.org ([205.233.56.17]:51070 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3GDLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:41:55 -0400
Date: Thu, 4 Jul 2013 07:41:53 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [WiP]: aio support for migrating pages (Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of get_user_pages() called get_user_pages_non_movable())
Message-ID: <20130704114153.GD11006@kvack.org>
References: <20130517002349.GI1008@kvack.org> <5195A3F4.70803@cn.fujitsu.com> <20130517143718.GK1008@kvack.org> <519AD6F8.2070504@cn.fujitsu.com> <20130521022733.GT1008@kvack.org> <51B6F107.80501@cn.fujitsu.com> <20130611144525.GB14404@kvack.org> <51D12E7B.6080301@cn.fujitsu.com> <20130702180008.GQ16399@kvack.org> <51D51B66.3000301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D51B66.3000301@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 02:51:18PM +0800, Gu Zheng wrote:
> Hi Ben,
>       When I test your patch on kernel 3.10, the kernel panic when aio job
> complete or exit, exactly in aio_free_ring(), the following is a part of dmesg.

What is your test case?

		-ben
