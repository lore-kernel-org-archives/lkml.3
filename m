Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967431Ab3DRP61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:58:27 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:55244
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932150Ab3DRP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:58:26 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIda00hdc73hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahz8dhz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kyle Evans <kvans32@gmail.com>
CC: =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after
 fabf85e3ca15d5b94058f391dac8df870cdd427a
Thread-Topic: BUG: Fn keys not working on EliteBook 8460p after
 fabf85e3ca15d5b94058f391dac8df870cdd427a
Thread-Index: AQHON+adNavXer7tn0G8FZnibr/8P5jTXnMAgAC464CAAD66gIAAFbyAgASio4CAAYSJAIAAJ70AgAFOI4CAACJngA==
Date: Thu, 18 Apr 2013 15:58:17 +0000
Message-ID: <1366300697.13667.15.camel@x230.lan>
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>
	    <51695169.6090306@gmail.com> <1365870087.13667.7.camel@x230.lan>
	   <51699843.7060905@gmail.com> <1366129583.13667.11.camel@x230.lan>
	  <516EC19C.3010906@gmail.com> <1366221554.13667.13.camel@x230.lan>
	 <516FFB3D.3060002@gmail.com>
In-Reply-To: <516FFB3D.3060002@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <375CFE6809895F418419134A4C8593C1@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3IFwYuD018234

On Thu, 2013-04-18 at 09:55 -0400, Kyle Evans wrote:

> 0x9(write), or SHKS, is essentially ec_write(SFHK,Arg0). Arg0 turns out 

Oh - try changing

int query = 1

to 

int query=0x6e

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
