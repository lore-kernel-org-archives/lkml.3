Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaGAPp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:45:56 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52202 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaGAPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:45:55 -0400
Message-ID: <53B2D7A6.1040901@6wind.com>
Date: Tue, 01 Jul 2014 17:45:42 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org
CC: linux-kernel@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched: fix warnings in linux/sched.h
References: <1403687411-27059-1-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1403687411-27059-1-git-send-email-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 25/06/2014 11:10, Nicolas Dichtel a écrit :
> Seen when compiling with W=1.
>
> Warnings were:
> In file included from arch/x86/kernel/asm-offsets.c:9:0:
> include/linux/sched.h:875:25: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
> include/linux/sched.h:882:25: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
> include/linux/sched.h:1002:21: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
>
> It was introduced by commit 143e1e28cb40 ("sched: Rework sched_domain topology
> definition").
>
> CC: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Any comment or problem about this patch?
