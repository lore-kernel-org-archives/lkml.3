Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3CKFKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:10:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:12276 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3CKFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:10:22 -0400
X-Spam-Score: -106.8
Message-ID: <513D6725.1080600@asianux.com>
Date: Mon, 11 Mar 2013 13:09:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Chen Gang <gang.chen@asianux.com>, tj@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, glommer@parallels.com,
        fweisbec@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/res_counter.h: fixup commit 9259826ccb8165f797e4c2c9d17925b41af5f6ae
References: <513BFA37.4040100@asianux.com> <513D2FF1.30300@huawei.com>
In-Reply-To: <513D2FF1.30300@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月11日 09:14, Li Zefan 写道:
> On 2013/3/10 11:12, Chen Gang wrote:
>> > 
>> >   still need include linux/errno.h for EBUSY.
>> > 
>> > additional info:
>> >   make command:
>> >     make EXTRA_CFLAGS=-W V=1 ARCH=arm allmodconfig
>> >     make EXTRA_CFLAGS=-W V=1 ARCH=arm
>> >   error report:
>> >     In file included from mm/memcontrol.c:28:0:
>> >     include/linux/res_counter.h: in function ‘res_counter_set_limit’:
>> >     include/linux/res_counter.h:204:13: error ：‘EBUSY’ is not declared.
>> > 
> Thanks, but Geert Uytterhoeven already sent the same patch.

  ok.

-- 
Chen Gang

Asianux Corporation
