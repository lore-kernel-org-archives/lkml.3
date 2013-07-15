Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3GOEzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 00:55:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:20518 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3GOEzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 00:55:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,667,1367996400"; 
   d="scan'208";a="268321980"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [3.10.1 MEI_ME] strange kernel crash
Thread-Topic: [3.10.1 MEI_ME] strange kernel crash
Thread-Index: AQHOgQR72w8jR9RSRkCx0mBY87vJnZllLLwg
Date: Mon, 15 Jul 2013 04:55:13 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B028E903A@HASMSX106.ger.corp.intel.com>
References: <51E2FE1C.207@openvz.org> <51E360C1.10204@openvz.org>
In-Reply-To: <51E360C1.10204@openvz.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6F4tPua006309



> -----Original Message-----
> From: Konstantin Khlebnikov [mailto:koct9i@gmail.com] On Behalf Of
> Konstantin Khlebnikov
> Sent: Monday, July 15, 2013 05:39
> To: linux-kernel@vger.kernel.org; Winkler, Tomas; linux-
> wireless@vger.kernel.org
> Subject: Re: [3.10.1 MEI_ME] strange kernel crash
> 
> This has happened again. This time without warnings and without suspend-
> resume.
> Seems like 'mei_me' corrupts kernel memory.

I will post the fix today I hope.

Thanks
Tomas

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
