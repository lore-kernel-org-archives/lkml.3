Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3HTHgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:36:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:9796 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3HTHgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:36:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,918,1367996400"; 
   d="scan'208";a="348795561"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: RE: [ 00/34] 3.4.59-stable review
Thread-Topic: [ 00/34] 3.4.59-stable review
Thread-Index: AQHOnSvKoRb0OTzpkki8rSvjSssr4pmdtSuQ
Date: Tue, 20 Aug 2013 07:36:00 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AA6B9CC@IRSMSX102.ger.corp.intel.com>
References: <20130818203259.653403173@linuxfoundation.org>
 <52125DA9.3090601@samsung.com> <20130819193538.GB24897@kroah.com>
 <201308192214.54917.s.L-H@gmx.de> <52129AC3.5020402@samsung.com>
 <20130819223037.GA3838@kroah.com>
In-Reply-To: <20130819223037.GA3838@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7K7aFor011348

> > [ 26/34] genetlink: fix family dump race
> 
> Johannes, another strike against this patch :(
> 
> Any chance on fixing it upstream and me sucking that fix in?

Yeah, I'm trying to get that, but it's not clear to me how to fix it. Where did you apply it? It was going to need some fixes but when the first objection was raised I figured you were going to drop it for now completely? Sorry for the mess :-(

johannes
-- 

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
