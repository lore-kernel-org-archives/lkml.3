Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab3CZMZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:25:54 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52832 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570Ab3CZMZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:25:53 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.123.88]
In-Reply-To: <87wqsvdc1j.fsf@rustcorp.com.au>
References: <CAPgLHd_GCM6HPsbFmj1YfBbQ2VMTzdsNJuoDvDmyaZ2DCnWNXw@mail.gmail.com>
 <87wqsvdc1j.fsf@rustcorp.com.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 26 Mar 2013 14:25:31 +0200
Message-ID: <CAK=WgbaSO6WHVsaqLhYNciz1t626V59dWBtj_8amwb3J0RcFVA@mail.gmail.com>
Subject: Re: [PATCH -next] rpmsg: fix error return code in rpmsg_probe()
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 12:11 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Wei Yongjun <weiyj.lk@gmail.com> writes:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return a negative error code from the error handling
>> case instead of 0, as returned elsewhere in this function.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Thanks, I've taken this for the moment in my pending queue.

Please note that akpm already picked this up via the -mm tree very
promptly after Wei submitted this.

> Which brings the questionL Ohad, did you want to keep pushing your own
> tree or want to send rpmsg stuff via my virtio-next tree?

I'm thinking I'll keep pushing my tree for now but I'm taking this as an
open offer from you :)

Thanks,
Ohad.
