Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3CAQn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:43:29 -0500
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:45373
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab3CAQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:43:28 -0500
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 11:43:27 EST
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dIc89bh936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] x86 platform driver bugfixes for 3.8
Thread-Topic: [GIT] x86 platform driver bugfixes for 3.8
Thread-Index: AQHOFoklOkBimkH4Q0aD3iFGocHqNZiRBlqA
Date: Fri, 1 Mar 2013 16:27:50 +0000
Message-ID: <1362155269.7780.3.camel@x230>
References: <20130107171722.GA31427@srcf.ucam.org>
	 <CA+55aFzL00K+oURqcnSgbAAkD18DJ8-p1G8vd7KE6RD77dLmCQ@mail.gmail.com>
	 <20130107172616.GB31427@srcf.ucam.org>
	 <20130107174306.GC31427@srcf.ucam.org> <87txov44y0.fsf@nemi.mork.no>
In-Reply-To: <87txov44y0.fsf@nemi.mork.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5236C9FF865737489B99B47509E57415@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r21GhUHD021604

On Fri, 2013-03-01 at 14:36 +0100, BjÃ¸rn Mork wrote:
> Matthew Garrett <matthew.garrett@nebula.com> writes:
> 
> > This set covers regressions and two obvious bugfixes. The rest can wait 
> > for 3.9.
> 
> Sorry for nagging, but I assume the 3.9 merge window will close over the
> weekend and I haven't seen the pull request for the rest of these posted
> yet.  I hope that still is the plan?

Ah, sorry, looks like I typoed the address for the mailing list.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
