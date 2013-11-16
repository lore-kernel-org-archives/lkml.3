Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3KPIAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:00:21 -0500
Received: from 1wt.eu ([62.212.114.60]:50056 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3KPIAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:00:17 -0500
Date: Sat, 16 Nov 2013 08:55:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Ben Greear <greearb@candelatech.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [ 146/184] softirq: reduce latencies
Message-ID: <20131116075557.GE11858@1wt.eu>
References: <20130604172136.354293911@1wt.eu> <51FB6A55.8080306@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB6A55.8080306@huawei.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

I just found your mail unread in my box by pure luck, I'm sorry.

On Fri, Aug 02, 2013 at 04:14:13PM +0800, Li Zefan wrote:
> Cc: Ben Greear
> Cc: Tejun
> 
> Hi Willy,
> 
> This patch introduced a bug, which was then fixed by commit 34376a50fb1f
> ("Fix lockup related to stop_machine being stuck in __do_softirq."),
> do we need this fix for 2.6.32 ?

Yes, I just checked the code and in doubt I think it's safer to apply it
as well. So I'm queuing the fix for .62, thanks !

Willy

