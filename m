Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaHFMRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:17:18 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:45505 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbaHFMRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:17:17 -0400
From: "Koehrer Mathias (ETAS/ESW5)" <mathias.koehrer@etas.com>
To: Nick Krause <xerofoify@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: PROBLEM: [x86] Running ptpd2 using an Intel 82572EI (e1000e)
 leads to a kernel oops (3.12.26)
Thread-Topic: PROBLEM: [x86] Running ptpd2 using an Intel 82572EI (e1000e)
 leads to a kernel oops (3.12.26)
Thread-Index: Ac+v3yzc3cSLCNWNSz2wcfBA1YE8+gBHlF+AABhU8HD///8TAP//3aGQ
Date: Wed, 6 Aug 2014 12:17:10 +0000
Message-ID: <d7c17267f87c4e64a1559fa706cf1ead@FE-MBX1012.de.bosch.com>
References: <50f83e65cecd4882b22887858bfdf484@FE-MBX1012.de.bosch.com>
	<CAPDOMVieG6RoOyQM1JG5vCQ1qSgqz-cy37X9GPnkzPUTyRBFBA@mail.gmail.com>
	<ff2e6995521f40268c42d09e92cfe627@FE-MBX1012.de.bosch.com>
 <CAPDOMVgFA-jTL=iDD2vLzPHrsO_=qsupAebTSUm0k0VmmHvX6A@mail.gmail.com>
In-Reply-To: <CAPDOMVgFA-jTL=iDD2vLzPHrsO_=qsupAebTSUm0k0VmmHvX6A@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.5.148.126]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s76CHOgR010978

> Mathias ,
> After tracing this it seems to be either one of two things based on
> the warn on messages in
> __queue_work. Normally it would be because of this line.
> WARN_ON_ONCE(!irqs_disabled());.
> However it would also be the second warn on, If you want I can send a
> simple patch with
> a printk statement to see which one it is.
> Regards Nick
That would be helpful. I can try to see what's happening.

Regards

Mathias
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
