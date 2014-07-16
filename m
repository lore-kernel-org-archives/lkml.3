Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbaGPQKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:10:45 -0400
Received: from blu004-omc4s1.hotmail.com ([65.55.111.140]:63149 "EHLO
	BLU004-OMC4S1.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934607AbaGPQKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:10:41 -0400
X-TMN: [JIpDUl3N6tmnet8DSJ0/V5h7KYU1r5tD]
X-Originating-Email: [beanhuo@outlook.com]
Message-ID: <BLU185-W360A909A392A2B589A7905A6F70@phx.gbl>
From: Bean Huo <beanhuo@outlook.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>
Subject: RE: [PATCH v5] mtd:nor:timeout:fix do_write_buffer() timeout error
Date: Wed, 16 Jul 2014 16:10:40 +0000
Importance: Normal
In-Reply-To: <003f01cfa0df$d79d5fc0$86d81f40$%han@samsung.com>
References: <BLU185-W10713E955F9530C4D53490A6F70@phx.gbl>,<BLU185-W62B0858FCD7D3A71127B41A6F70@phx.gbl>,<002201cfa0ca$be634b10$3b29e130$%han@samsung.com>,<BLU185-W44C89261B8307EBFCC2EC0A6F70@phx.gbl>,<003f01cfa0df$d79d5fc0$86d81f40$%han@samsung.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jul 2014 16:10:40.0968 (UTC) FILETIME=[7D3C3480:01CFA110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6GGApjT029210

> However, one thing is clear; 'if' and 'else' should use the same
> indentation level as below.
>
> 1.
> if(){
> ...
> } else {
> ...
> }
>
> 2.
> if(){
> ...
> } else {
> ...
> }
>
> 3.
>
> if(){
> ...
> } else {
> ...
> }
>
> Best regards,
> Jingoo Han

hi,Jinngoo
I'm sorry for misunderstanding for you suggestion,and I will modify my patch in V6.thanks. 		 	   		  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
