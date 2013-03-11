Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3CKBPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:15:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:58523 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3CKBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:15:17 -0400
Message-ID: <513D2FF1.30300@huawei.com>
Date: Mon, 11 Mar 2013 09:14:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: <tj@kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>, <glommer@parallels.com>,
        <fweisbec@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/res_counter.h: fixup commit 9259826ccb8165f797e4c2c9d17925b41af5f6ae
References: <513BFA37.4040100@asianux.com>
In-Reply-To: <513BFA37.4040100@asianux.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/10 11:12, Chen Gang wrote:
> 
>   still need include linux/errno.h for EBUSY.
> 
> additional info:
>   make command:
>     make EXTRA_CFLAGS=-W V=1 ARCH=arm allmodconfig
>     make EXTRA_CFLAGS=-W V=1 ARCH=arm
>   error report:
>     In file included from mm/memcontrol.c:28:0:
>     include/linux/res_counter.h: in function ¡®res_counter_set_limit¡¯:
>     include/linux/res_counter.h:204:13: error £º¡®EBUSY¡¯ is not declared.
> 

Thanks, but Geert Uytterhoeven already sent the same patch.

