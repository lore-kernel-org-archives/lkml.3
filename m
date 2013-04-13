Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3DMBfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:35:14 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:1446
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426Ab3DMBfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:35:12 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dIc89bh936eI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Kyle Evans <kvans32@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after
 fabf85e3ca15d5b94058f391dac8df870cdd427a
Thread-Topic: BUG: Fn keys not working on EliteBook 8460p after
 fabf85e3ca15d5b94058f391dac8df870cdd427a
Thread-Index: AQHON+adNavXer7tn0G8FZnibr/8P5jTXnMA
Date: Sat, 13 Apr 2013 01:35:06 +0000
Message-ID: <1365816906.13667.6.camel@x230.lan>
References: <201304130331.18301@pali>
In-Reply-To: <201304130331.18301@pali>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA581A5DE28E2B4BA24442D038A5A2CC@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3D1ZMpw017460

On Sat, 2013-04-13 at 03:31 +0200, Pali RohÃ¡r wrote:

> all Fn keys, wifi switch, web and mute buttons not working anymore 
> on my notebook HP EliteBook 8460p. I bisected git commit which 
> broke all above keys: fabf85e3ca15d5b94058f391dac8df870cdd427a
> 
> When I reverted that commit after reboot buttons started working 
> again. Can you fix it or revert that broken commit? This is 
> critical problem, which caused my notebook to be unusable...

Sure, I'll revert that. Kyle, can you look into figuring out a way to
only run this on machines that need it?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
