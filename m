Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaEVAAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:00:08 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:51581 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbaEVAAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:00:06 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.479
Date: Thu, 22 May 2014 07:59:55 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <256522481.45786.1400716795052.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537C7258.2010304@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_R?=
 =?utf-8?Q?e:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]?=
 =?utf-8?Q?_arch/unicore32/kernel/setup?=
 =?utf-8?Q?.c:_add_generic_'screen=5Finfo'_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> 
> 
> On 05/21/2014 05:23 PM, 管雪涛 wrote:
> > 
> > ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> >>
> >> Yeah, I shall send patch v2 for it (within this week). And also thank
> >> you for your review the other patches.
> >>
> >> BTW: I guess, it only leaves 2 kernel related issues for allmodconfig:
> >>
> >>  - one for 'find_first*', 'cpuc_coherent_kern_range' and 'pm_power_off'.
> >>    I guess, we can export their symbol explicitly to fix this issue.
> > 
> > My suggestion:
> >  find_first_* could export themselves in lib/find_first.c, so each archs can use it.
> >    anyway, we can first add them in unicore32, and then make it a generic lib.
> >  what's the problem with cpuc_coherent_kern_range? in fact, I'll remove it later.
> >  pm_power_off need be exported.
> > 
> 
> Thank you for your suggestions, and if you have already fixed them
> (maybe you have done), please let me know. Or I shall send them within
> this month.
> 
> The related error for 'cpu_coherent_kern_rage':
> 
>   ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!
> 
> >>
> >>  - the other for additional 'clk_*' which are needed when HAVE_CLK.
> >>    I guess, just "copy/past" the other platforms' implementation is OK.
> > 
> > Maybe, COMMON_CLK should be selected. I'm not sure.
> > 
> 
> I guess so, if you have already fix it (maybe you have done, I am not
> quite familiar with version merging of Linux kernel), please let me
> know. Or I shall process (continue think of) it within this month.

Ok, I'll arrange this work, but maybe finish it in next month.

> 
> 
> Thanks.
> -- 
> Chen Gang
> 
> Open, share, and attitude like air, water, and life which God blessed

