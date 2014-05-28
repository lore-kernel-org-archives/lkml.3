Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaE1IQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:16:50 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58704 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaE1IQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:16:48 -0400
Message-ID: <1401265004.9793.19.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org, Huang Qiang <h.huangqiang@huawei.com>
Date: Wed, 28 May 2014 10:16:44 +0200
In-Reply-To: <5385881D.4090601@huawei.com>
References: <5382AF2E.1040407@huawei.com>
	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>
	 <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com>
	 <1401184553.5134.115.camel@marge.simpson.net> <53848A2C.5010209@huawei.com>
	 <1401196807.5134.132.camel@marge.simpson.net> <53853604.50500@huawei.com>
	 <1401242038.4721.14.camel@marge.simpson.net> <5385881D.4090601@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 14:54 +0800, Libo Chen wrote: 
> On 2014/5/28 9:53, Mike Galbraith wrote:
> > On Wed, 2014-05-28 at 09:04 +0800, Libo Chen wrote:
> > 
> >> oh yes, no tsc only hpet in my box.
> > 
> > Making poor E5-2658 box a crippled wreck.
> 
> yes,it is. But cpu usage will be down from 15% to 5% when binding cpu, so maybe read_hpet
> is not the root cause.

I don't think anyone will be particularly interested in making kernel
changes based upon the behavior of a broken box.  The problem we were
discussing is real enough though, it's just a question of severity.

-Mike

