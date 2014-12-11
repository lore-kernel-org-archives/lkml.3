Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaLKCXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:23:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61740 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541AbaLKCXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:23:39 -0500
X-AuditID: cbfee68d-f79296d000004278-26-5489002974c1
Message-id: <54890028.1080105@samsung.com>
Date: Thu, 11 Dec 2014 11:23:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: weiyj_lk@163.com
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] extcon: Remove duplicated include from extcon-class.c
References: <1418087319-14416-1-git-send-email-weiyj_lk@163.com>
In-reply-to: <1418087319-14416-1-git-send-email-weiyj_lk@163.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSpKvJ0BlisHivuMXlXXPYLG43rmCz
	aPv3g8li57pOdgcWj8UrprB69G1Zxeix9N5RRo/Pm+QCWKK4bFJSczLLUov07RK4Mua/7mYu
	6GaruHjuIGMD42+WLkZODgkBE4kb8/8yQ9hiEhfurWcDsYUEljJKPL8pBlNzt+8DUJwLKD6d
	UWLxsi8sEM5rRok575oZuxg5OHgFtCQOHrcCaWARUJWYPfcp2CA2oPD+FzfAbFGBMImV06+A
	LeYVEJT4MfkeC0iriICIRPeTSJAws0CFxLqGaewgtrBAgMSJF8tYIO5xkNg3dwPQnewcnAKO
	Egv1IKp1JPa3TmODsOUlNq95ywxymITAOnaJTUcOs0NcIyDxbfIhsE0SArISmw5AfSspcXDF
	DZYJjGKzkNwzC8nYWUjGLmBkXsUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRGEen/z3r3cF4
	+4D1IUYBDkYlHt6Ay+0hQqyJZcWVuYcYTYGumMgsJZqcD4zWvJJ4Q2MzIwtTE1NjI3NLMyVx
	XkWpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGK9xHm2/Xbbl08k+UaZpyo9V/qYYT3G1
	PNN+asOHfeWq6bNS2X/WWnuUKWfnhlv1Kr7PYi0v1w4s+3fr0oR8HQXrt56vd9287R2ecv/S
	1QMGE21mC5pmztxp7/xl57u0Dd35DO5v1556ZsFeaNV+PdtdfGmjmpDT8SjuhUeOKSY+WfDY
	b7XaESWW4oxEQy3mouJEAGaoXRyeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQV1Nhs4Qg5lrBC0u75rDZnG7cQWb
	Rdu/H0wWO9d1sjuweCxeMYXVo2/LKkaPpfeOMnp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYw5gx/3U3c0E3W8XFcwcZGxh/s3QxcnJICJhI3O37wAZhi0lcuLce
	yObiEBKYziixeNkXFgjnNaPEnHfNjF2MHBy8AloSB49bgTSwCKhKzJ77FKyZDSi8/8UNMFtU
	IExi5fQrYAt4BQQlfky+xwLSKiIgItH9JBIkzCxQIbGuYRo7iC0sECBx4sUysHIhAQeJfXM3
	MHcxsnNwCjhKLNSDqNaR2N86jQ3ClpfYvOYt8wRGgVlI5s9CUjYLSdkCRuZVjKKpBckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGMFx+kxqB+PKBotDjAIcjEo8vAGX20OEWBPLiitzDzFKcDArifAm
	3egIEeJNSaysSi3Kjy8qzUktPsRoCvT+RGYp0eR8YArJK4k3NDYxM7I0Mje0MDI2VxLnVbJv
	CxESSE8sSc1OTS1ILYLpY+LglGpgLG+4WZwlkPdBaJvioRsii07zfGioklRnXWZkveHJevFd
	5sdFr+5tXRxyKY3xPaNr3fTmAqYGzo0/Hh6xurv+c8UN3c58f4FtsQp3o+8HqsdJfxT6bBL8
	lvXeHM/NP9KilfWDA8ITWZS7Y4/v2yCVtjK52IMhXfb1T6sjgX3dB9y65D7McFiuxFKckWio
	xVxUnAgAUdgd4+kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On 12/09/2014 10:08 AM, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/extcon/extcon-class.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 043dcd9..8319f25 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -32,7 +32,6 @@
>  #include <linux/of.h>
>  #include <linux/slab.h>
>  #include <linux/sysfs.h>
> -#include <linux/of.h>
>  
>  /*
>   * extcon_cable_name suggests the standard cable names for commonly used
> 
> 

I'll apply it on extcon-next branch.

Thanks,
Chanwoo Choi
