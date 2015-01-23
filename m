Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbbAWBNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:13:30 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38648 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbbAWBN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:13:29 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0N1D2ID007885, This message is accepted by code: ctloc85258
From: =?gb2312?B?vrTI8Q==?= <micky_ching@realsil.com.cn>
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Keerthimai Janarthanan" <keerthimaipb@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Falzoi <fabio.falzoi84@gmail.com>,
        "Tina Johnson" <tinajohnson.1234@gmail.com>,
        Surya Seetharaman <surya.seetharaman9@gmail.com>
Subject: Re: [PATCH] staging: rts5028: use msecs_to_jiffies for timeouts
Thread-Topic: [PATCH] staging: rts5028: use msecs_to_jiffies for timeouts
Thread-Index: AQHQM7pK0ZLyxQpn5keVKEAMtFX8lpzK2y0AgAB7JYCAAQ+YgA==
Date: Fri, 23 Jan 2015 01:13:01 +0000
Message-ID: <54C1A021.3090805@realsil.com.cn>
References: <1421652347-8484-1-git-send-email-der.herr@hofr.at>
 <54C05500.8050809@realsil.com.cn> <20150122090101.GB27741@opentech.at>
In-Reply-To: <20150122090101.GB27741@opentech.at>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="gb2312"
Content-ID: <62C1546E78B8644DACA095EDB71071AC@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0N1DZ8Z030738


On 01/22/2015 05:01 PM, Nicholas Mc Guire wrote:
> sorry - that was a typo - should this be
> resubmitted for traceability or is that not
> necessary ?
resubmit, thanks.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
