Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaF0Hux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:50:53 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62315 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaF0Huv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:50:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: zhangfei <zhangfei.gao@linaro.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, haifeng.yan@linaro.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        jchxue@gmail.com, Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH v2 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
Date: Fri, 27 Jun 2014 09:50:46 +0200
Message-ID: <11262017.C011KreL6u@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53ACE6EE.4050300@linaro.org>
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <4989178.vejv39dnj8@wuerfel> <53ACE6EE.4050300@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZFoMd0ud1yVbrEuCft36j9hfS9yJ9MtC1ohmb0H9x6C
 BWhu8sKn0B0uJYQWTV7Zge/IAiuVxzRdBWuDBpGxl4gLyq8Vt9
 nO9DJsZLog4vwK3lqC74phYRq2w+AJVd04TPnCK+rX+xkw0y1H
 Ssv5xvChviWw9y0QhHpudDbxO0xqFTAsyN+E/qYSfa5JZlYeb7
 mOpUEr1Zcrim8KopBzD8qx3F5ospxJb7B+WzFWLcxBEN5noEHJ
 gvxF8kF2OulpNJ1j3Rq5CeQyA8KvuZBnWCwSlb05Roh6uIhWZG
 2fBvBXCeqbvetFtDte/U1+IxXtDzHm+vNqqf5N+pXJYvSDLJOp
 x/2XchJT03H2ea7c+i6k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2014 11:37:18 zhangfei wrote:
> >
> 
> Sorry for the confusion.
> 
> The phy is rather an analog controller, without standard register.
> Instead, the phy interface is just some pin / analog interface.
> The register is in fact hix5hd2 register, controls all the analog 
> output, including reset, power, speed, para tunning.

Ok, thanks for the explanation.

> Even the same phy is used in other soc, they can not share this driver, 
> since the connection must be different, as well as internal soc register 
> layout.
> Only if the same controller & phy are reused in other hisilicon soc, 
> this driver can be shared.
> 
> Since what we control is hix5hd2 controller itself, so it may not 
> suitable to put snps here.

Makes sense.

> And about hix5hd2 name: x is not wildcard.
> 
> Currently hix5hd2 is series of hi3716c v200, hi3719c v100, hi3718c v100.
> They are same soc, except minus pin assembles different.
> 
> However, not all hi37x is in this series, for example hi3716c v100 is a 
> different soc.
> 
> In the future hi3719m, hi3718m may also plan to add to hix5hd2 series.
> The difference will be different cpu core number, different gpu core 
> number. Also use different ethernet controller.

Ah, I think you explained this before, sorry for misremembering it.
 
> So we may still keep "hisilicon,hix5hd2-sata-phy" unchanged.
> What do you think?

Yes, please keep this string, it's good.

Thanks for your patience,

	Arnd
