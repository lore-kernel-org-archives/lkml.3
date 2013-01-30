Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3A3IHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:07:40 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38235 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab3A3IHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:07:37 -0500
X-Forefront-Antispam-Report: CIP:198.70.193.115;KIP:(null);UIP:(null);IPV:NLI;H:avcashub1.qlogic.com;RD:avcashub1.qlogic.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh936eI1432I4015Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2ei2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h1155h)
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Andrew Vasquez <andrew.vasquez@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] qla2xxx: silence two GCC warnings
Thread-Topic: [PATCH v3] qla2xxx: silence two GCC warnings
Thread-Index: AQHN/gcTyzytg8YPr0OLDU6yO8FZ+ZhiZ/OA
Date: Wed, 30 Jan 2013 08:07:31 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D045B19@AVMB1.qlogic.org>
In-Reply-To: <1359453426.1345.30.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.10.0.110310
x-originating-ip: [10.35.7.30]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE77B86CCA952B4BB91BC1FA4B5D4C5D@qlogic.com>
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0U87fup013091



>On Mon, 2012-10-08 at 11:15 -0500, Saurav Kashyap wrote:
>> Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>>
>> Thanks,
>> ~Saurav
>>
>> >Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
>> >warnings:
>> >    drivers/scsi/qla2xxx/qla_gs.c: In function Å’qla2x00_fdmi_rhbaÂ¹:
>> >    drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript is
>> >above array bounds [-Warray-bounds]
>> >    drivers/scsi/qla2xxx/qla_gs.c: In function Å’qla2x00_fdmi_registerÂ¹:
>> >    drivers/scsi/qla2xxx/qla_gs.c:1663:15: warning: array subscript is
>> >above array bounds [-Warray-bounds]
>
>This patch was originally posted to silence two GCC warnings while
>building v3.6-rc7. Basically identical warnings can still be seen while
>building v3.8-rc5. What's the status of this patch?

Hi Paul,
I am submitting some correction patches today and this patch will be part
of the scsi-misc submission after that set.

Thanks,
~Saurav
>
>
>Paul Bolle
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
