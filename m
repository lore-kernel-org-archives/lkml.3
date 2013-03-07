Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736Ab3CGUNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:13:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:60011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3CGUNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:13:46 -0500
Message-ID: <5138F518.1080808@infradead.org>
Date: Thu, 07 Mar 2013 12:14:16 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] sysrq: fix inconstistent help message of sysrq key
References: <51385712.3050104@huawei.com>
In-Reply-To: <51385712.3050104@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/13 01:00, zhangwei(Jovi) wrote:
> Currently help message of /proc/sysrq-trigger highlight its
> upper-case characters, like below:
> 
>       SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
>       memory-full-oom-kill(F) kill-all-tasks(I) ...
> 
> this would confuse user trigger sysrq by upper-case character, which is
> inconsistent with the real lower-case character registed key.
> 
> This inconsistent help message will also lead more confused when
> 26 upper-case letters put into use in future.
> 
> This patch fix it.
> 
> Thanks the comments from Andrew and Randy.
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>

for the patch series (1-8):
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/tty/sysrq.c |   38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)



-- 
~Randy
