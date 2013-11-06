Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3KFSHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:07:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab3KFSHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:07:46 -0500
From: "Gupta, Pekon" <pekon@ti.com>
To: Brian Norris <computersforpeace@gmail.com>,
        Wei Yongjun <weiyj.lk@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Daniel Mack <zonque@gmail.com>,
        "avinashphilip@ti.com" <avinashphilip@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] mtd: nand: omap: fix error return code in
 omap_nand_probe()
Thread-Topic: [PATCH -next] mtd: nand: omap: fix error return code in
 omap_nand_probe()
Thread-Index: AQHO1pecwFLnZOcECEijKtvUQDrmTJoPHfeAgAeTUoCAAdXdAA==
Date: Wed, 6 Nov 2013 18:06:25 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EA31818@DBDE04.ent.ti.com>
References: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
	<001101ced6a8$a18a2c80$e49e8580$%han@samsung.com>
 <CAN8TOE9Eac0LDA+Ke_OCPc_AQGnyYB806pO8JP-qOB1Dr8N2pg@mail.gmail.com>
In-Reply-To: <CAN8TOE9Eac0LDA+Ke_OCPc_AQGnyYB806pO8JP-qOB1Dr8N2pg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Brian Norris [mailto:computersforpeace@gmail.com]
> > On Thu, Oct 31, 2013 at 7:18 PM, Jingoo Han <jg1.han@samsung.com>
> >> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >>
> >> Fix to return a negative error code from the error handling
> >> case instead of 0, as done elsewhere in this function.
> >
> > Commit message is right? :-(
> 
> It sounds OK by my reading. Unless you're having trouble parsing what
> "as done elsewhere in this function" is being applied to. (IOW, is the
> rest of the function returning a negative error code on the error
> paths, or is it returning 0? Of course the answer is the former, but
> it's possible to misread it.) If it helps, I can try to tweak the
> wording a bit when applying this patch.
> 
> Pekon, can I get an Acked-by?
> 
Yes sure .. Sorry I was away from both mailbox and boards.
Acked-by: Pekon Gupta <pekon@ti.com>

And thanks much Wei Yongjun for fixing this .


with regards, pekon
