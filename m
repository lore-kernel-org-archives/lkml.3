Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3CYXAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:00:24 -0400
Received: from ozlabs.org ([203.10.76.45]:40358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3CYXAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:00:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wei Yongjun <weiyj.lk@gmail.com>, ohad@wizery.com,
        akpm@linux-foundation.org, tj@kernel.org, sboyd@codeaurora.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] rpmsg: fix error return code in rpmsg_probe()
In-Reply-To: <CAPgLHd_GCM6HPsbFmj1YfBbQ2VMTzdsNJuoDvDmyaZ2DCnWNXw@mail.gmail.com>
References: <CAPgLHd_GCM6HPsbFmj1YfBbQ2VMTzdsNJuoDvDmyaZ2DCnWNXw@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 25 Mar 2013 20:41:20 +1030
Message-ID: <87wqsvdc1j.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun <weiyj.lk@gmail.com> writes:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, I've taken this for the moment in my pending queue.

Which brings the questionL Ohad, did you want to keep pushing your own
tree or want to send rpmsg stuff via my virtio-next tree?

Cheers,
Rusty.
