Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3IPQTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:19:35 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45274 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3IPQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:19:34 -0400
Message-ID: <52372F9A.1080102@gmail.com>
Date: Mon, 16 Sep 2013 12:19:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jianguo Wu <wujianguo@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] mm/mempolicy: use NUMA_NO_NODE
References: <5236FF32.60503@huawei.com>
In-Reply-To: <5236FF32.60503@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(9/16/13 8:53 AM), Jianguo Wu wrote:
> Use more appropriate NUMA_NO_NODE instead of -1
>
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> ---
>   mm/mempolicy.c |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)

I think this patch don't make any functional change, right?

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


