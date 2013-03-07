Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab3CGV11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:27:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46338 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815Ab3CGV10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:27:26 -0500
Date: Thu, 07 Mar 2013 16:27:24 -0500 (EST)
Message-Id: <20130307.162724.2043364205781900432.davem@davemloft.net>
To: jovi.zhangwei@huawei.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] spare/sysrq: fix inconstistent help message of
 sysrq key
From: David Miller <davem@davemloft.net>
In-Reply-To: <51385730.7020606@huawei.com>
References: <51385730.7020606@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 07 Mar 2013 13:27:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Date: Thu, 7 Mar 2013 17:00:32 +0800

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
> This patch fix spare sysrq key: "global-regs(y)"
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>

Acked-by: David S. Miller <davem@davemloft.net>
