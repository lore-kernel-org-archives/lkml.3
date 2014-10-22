Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaJVICv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:02:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40888 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaJVICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:02:47 -0400
Message-ID: <5447648C.1050405@huawei.com>
Date: Wed, 22 Oct 2014 16:02:20 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, <acme@kernel.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <jolsa@redhat.com>, <adrian.hunter@intel.com>, <Waiman.Long@hp.com>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>
Subject: Re: [PATCH v2] perf tools: makes CPUINFO_PROC to array for different
 kernel version
References: <1413963582-7174-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1413963582-7174-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/22 15:39, Wang Nan wrote:
> euler inclusion
> target: kernel 3.10
> category: bugfix
> DTS: DTS2014101306477
> Bugzilla: 623
> directory: upstreamed
> archive: https://lkml.org/lkml/2014/10/15/611
> 
> ----------------------------------------
> 

Sorry, the header is for our internal use only.

Please ignore it and see

https://lkml.org/lkml/2014/10/22/85

Thanks.

> After kernel 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
> /proc/cpuinfo replaces 'Processor' to 'model name'. This patch makes
> CPUINFO_PROC to an array and provides two choices for ARM, makes it
> compatible for different kernel version.
> 
> v1 -> v2: minor changes as suggested by Namhyung Kim:
> 
>  - Doesn't pass @h and @evlist to __write_cpudesc;
>  - Coding style fix.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Namhyung Kim <namhyung@kernel.org>


