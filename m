Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab3KMRO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:14:57 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49262 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3KMROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:14:48 -0500
Message-ID: <5283C19D.4050601@cogentembedded.com>
Date: Wed, 13 Nov 2013 21:14:53 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-sh@vger.kernel.org,
        lethal@linux-sh.org
CC: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, kbuild-all@01.org
Subject: Re: [PATCH] sh: fix kernel build error
References: <1384353504-21886-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1384353504-21886-1-git-send-email-gaowanlong@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/13/2013 05:38 PM, Wanlong Gao wrote:

>     arch/sh/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
>>> arch/sh/kernel/kgdb.c:225:32: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]
>>> arch/sh/kernel/kgdb.c:242:23: error: dereferencing pointer to incomplete type
>>> arch/sh/kernel/kgdb.c:243:22: error: dereferencing pointer to incomplete type
>     arch/sh/kernel/kgdb.c: In function 'singlestep_trap_handler':
>>> arch/sh/kernel/kgdb.c:310:27: error: 'SIGTRAP' undeclared (first use in this function)
>     arch/sh/kernel/kgdb.c:310:27: note: each undeclared identifier is reported only once for each function it appears in
>     cc1: all warnings being treated as errors

    Strange quoting...

> This is introduced by commit 16559ae.

    Please also specify that commit's summary line in parens.

> CC: kbuild-all@01.org
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

WBR, Sergei

