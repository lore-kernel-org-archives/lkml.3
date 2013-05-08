Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3EHSBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:01:43 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:30949 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3EHSBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:01:41 -0400
Message-ID: <518A9304.9010809@tilera.com>
Date: Wed, 8 May 2013 14:01:40 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <a.zummo@towertech.it>, <akpm@linux-foundation.org>,
        <yongjun_wei@trendmicro.com.cn>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: rtc-tile: add missing platform_device_unregister()
 when module exit
References: <CAPgLHd86cg11pHka0TRMFkEJV2ETLHwnr3oUo=FpBYnSLk=8sA@mail.gmail.com>
In-Reply-To: <CAPgLHd86cg11pHka0TRMFkEJV2ETLHwnr3oUo=FpBYnSLk=8sA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/2013 1:07 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> We have registered platform device when module init, and
> need unregister it when module exit.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/rtc/rtc-tile.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks.  Taken into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
