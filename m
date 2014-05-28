Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaE1Gyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:54:38 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12005 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaE1Gyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:54:36 -0400
Message-ID: <5385881D.4090601@huawei.com>
Date: Wed, 28 May 2014 14:54:21 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>, Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com>	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>	 <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com>	 <1401184553.5134.115.camel@marge.simpson.net> <53848A2C.5010209@huawei.com>	 <1401196807.5134.132.camel@marge.simpson.net> <53853604.50500@huawei.com> <1401242038.4721.14.camel@marge.simpson.net>
In-Reply-To: <1401242038.4721.14.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/28 9:53, Mike Galbraith wrote:
> On Wed, 2014-05-28 at 09:04 +0800, Libo Chen wrote:
> 
>> oh yes, no tsc only hpet in my box.
> 
> Making poor E5-2658 box a crippled wreck.

yes,it is. But cpu usage will be down from 15% to 5% when binding cpu, so maybe read_hpet
is not the root cause.

thanks,
Libo

> 
> -Mike
> 
> 
> 


