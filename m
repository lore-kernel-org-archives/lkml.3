Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab3CMRnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:43:23 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:39233 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3CMRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <3676378.u1106u4Bhi@avalon>
References: <CAPgLHd-SZw14C_jDYrGNyYWJ7XafX--NEaF9+QofAcm9CuFK_w@mail.gmail.com>
	<3676378.u1106u4Bhi@avalon>
Date: Wed, 13 Mar 2013 18:43:21 +0100
Message-ID: <CACRpkdY00v2xk6u+bM66uZCDa8MobiP+k7gN=QfjB4nb+mHhjQ@mail.gmail.com>
Subject: Re: [PATCH -next] sh-pfc: fix return value check in sh_pfc_register_pinctrl()
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, horms+renesas@verge.net.au,
        lethal@linux-sh.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:47 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Wei,
>
> Thank you for the patch.
>
> On Monday 11 March 2013 22:08:12 Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> In case of error, the function pinctrl_register() returns
>> NULL not ERR_PTR(). The IS_ERR() test in the return value
>> check should be replaced with NULL test.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> I've taken the patch in my tree and will push it to v3.10.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
