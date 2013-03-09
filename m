Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab3CIKlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 05:41:39 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:8317 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3CIKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 05:41:37 -0500
Message-ID: <513B11C8.5030504@huawei.com>
Date: Sat, 9 Mar 2013 18:41:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Tejun Heo <tj@kernel.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] res_counter: Add missing #include <linux/errno.h>
References: <1362819077-14211-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1362819077-14211-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/9 16:51, Geert Uytterhoeven wrote:
> Commit 9259826ccb8165f797e4c2c9d17925b41af5f6ae ("res_counter: remove
> include of cgroup.h from res_counter.h") removed the indirect inclusion of
> <linux/errno.h>, breaking the build on m68k and sparc:
> 
> In file included from mm/memcontrol.c:29:
> include/linux/res_counter.h: In function ‘res_counter_set_limit’:
> include/linux/res_counter.h:203: error: ‘EBUSY’ undeclared (first use in this function)
> include/linux/res_counter.h:203: error: (Each undeclared identifier is reported only once
> include/linux/res_counter.h:203: error: for each function it appears in.)
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Li Zefan <lizefan@huawei.com>

