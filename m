Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3CODCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:02:55 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60659 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3CODCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9BkPUDrgg5jsexFD08=d_ExujMSQmDQd0=9sX5CbPpDg@mail.gmail.com>
References: <CAPgLHd9BkPUDrgg5jsexFD08=d_ExujMSQmDQd0=9sX5CbPpDg@mail.gmail.com>
Date: Fri, 15 Mar 2013 07:02:52 +0400
Message-ID: <CAMo8BfLuOix9uaUM9xmMBmZBwT0X4A_MSr9Ne7t2Nj--UBYdww@mail.gmail.com>
Subject: Re: [PATCH] xtensa: net: fix invalid use of sizeof in iss_net_setup()
From: Max Filippov <jcmvbkbc@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: chris@zankel.net, yongjun_wei@trendmicro.com.cn,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 6:06 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> sizeof() when applied to a pointer typed expression gives the
> size of the pointer, not that of the pointed data.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/xtensa/platforms/iss/network.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
