Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3DMRm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 13:42:27 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55706 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab3DMRm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 13:42:26 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI98dI9371I936eI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahz8dhz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
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
Thread-Index: AQHON+adNavXer7tn0G8FZnibr/8P5jTXnMAgAC464CAAD66gIAAFbyAgAAA0oA=
Date: Sat, 13 Apr 2013 17:42:12 +0000
Message-ID: <1365874931.13667.8.camel@x230.lan>
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>
	  <51695169.6090306@gmail.com> <1365870087.13667.7.camel@x230.lan>
	 <51699843.7060905@gmail.com>
In-Reply-To: <51699843.7060905@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7884D515521BA41BC167F1258716553@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3DHgXwL020006

On Sat, 2013-04-13 at 13:39 -0400, Kyle Evans wrote:
> On 04/13/2013 12:21 PM, Matthew Garrett wrote:
> > On Sat, 2013-04-13 at 08:36 -0400, Kyle Evans wrote:
> >> Sure, sorry about that. I was hoping the GUID would be enough. I'll see
> >> what I can come up with.
> > Sure there's no WMI method that makes the EC write? It's a little weird
> > for WMI drivers to have to hit the EC directly.
> >
> I have no idea, I didn't know what a DSDT was before trying to get these 
> buttons working.

Got a copy of your ACPI tables?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
