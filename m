Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab3CHA74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:59:56 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:37912 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760097Ab3CHA7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:59:55 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 01/16] spi/spi-atmel: fix master->num_chipselect
 wrongly set.
Thread-Topic: [PATCH v5 01/16] spi/spi-atmel: fix master->num_chipselect
 wrongly set.
Thread-Index: AQHOE+2fSjtTCeM8bUCJ0PBTbEJUqJiSibiAgAh8K0A=
Date: Fri, 8 Mar 2013 00:59:43 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436414971AE03@penmbx02>
References: <1361861289-30332-1-git-send-email-wenyou.yang@atmel.com>
 <1361861289-30332-2-git-send-email-wenyou.yang@atmel.com>
 <20130302231535.8E6043E35BE@localhost>
In-Reply-To: <20130302231535.8E6043E35BE@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r280xuBu025449

> -----Original Message-----
> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> Sent: 2013Äê3ÔÂ3ÈÕ 7:16
> To: Yang, Wenyou; linux-arm-kernel@lists.infradead.org
> Cc: Ferre, Nicolas; plagnioj@jcrosoft.com; richard.genoud@gmail.com; Lin, JM;
> Yang, Wenyou; spi-devel-general@lists.sourceforge.net;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v5 01/16] spi/spi-atmel: fix master->num_chipselect
> wrongly set.
> 
> On Tue, 26 Feb 2013 14:47:54 +0800, Wenyou Yang <wenyou.yang@atmel.com>
> wrote:
> > if the spi property "cs-gpios" is set as below:
> >
> > 	cs-gpios = <0>, <&pioC 11 0>, <0>, <0>;
> >
> > the master->num_chipselect will wrongly be set to 0,
> > and the spi fail to probe.
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: spi-devel-general@lists.sourceforge.net
> > Cc: linux-kernel@vger.kernel.org
> 
> I think I've got this bug fixed in the core spi code. Give it a couple
> of days and retest with linux-next.
Hi Grant,

Yes, in v3.9-rc1 this bug fixed, I retested on v3.9-rc1.
But on "spi/next" git tree, it should to apply this patch.

I sent the patches version 6, could you take a look them? 
Thanks a lot for your work.

> 
> g.

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
