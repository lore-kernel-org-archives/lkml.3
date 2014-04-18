Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaDRKTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:19:50 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41158 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRKTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:19:47 -0400
Date: Fri, 18 Apr 2014 12:19:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        heiko.carstens@de.ibm.com
Subject: Re: [PATCH 17/17] sched: Get rid of opened code implementation of
 funtion nice_to_rlimit().
Message-ID: <20140418101942.GA21711@gmail.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
 <220c27487540603b7af88ef327600804212a6706.1394532288.git.yangds.fnst@cn.fujitsu.com>
 <20140418100111.GA29098@gmail.com>
 <5350ED15.7070103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5350ED15.7070103@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> On 04/18/2014 07:01 PM, Ingo Molnar wrote:
> >So the patch title has two typos and a superfluous period.
> 
> Really sorry for that. :( I will update it right now.

Please wait for the next -tip update before you resend the series - 
I've applied a handful of other patches from you, which will reduce 
the size of your queue.

Thanks,

	Ingo
