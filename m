Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3JJQGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:06:48 -0400
Received: from mail-bn1lp0151.outbound.protection.outlook.com ([207.46.163.151]:17461
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab3JJQGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:06:45 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "corentin.chary@gmail.com" <corentin.chary@gmail.com>
CC: "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
Thread-Topic: [PATCH v2] platform: x86: asus-wmi: add fan control
Thread-Index: AQHOxCWSnrH046wXjk2IRhS/h+9JZJnuGyYAgAAB9oA=
Date: Thu, 10 Oct 2013 16:06:40 +0000
Message-ID: <1381421199.4248.2.camel@x230.lan>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
	 <CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
In-Reply-To: <CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0995196AA2
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(199002)(189002)(51704005)(19580405001)(19580395003)(83072001)(83322001)(80976001)(36756003)(74662001)(47446002)(74502001)(31966008)(74876001)(74366001)(80022001)(49866001)(79102001)(46102001)(51856001)(63696002)(56816003)(77096001)(47976001)(50986001)(81816001)(65816001)(47736001)(85306002)(54356001)(74706001)(4396001)(54316002)(81342001)(56776001)(69226001)(81686001)(53806001)(76796001)(76786001)(33646001)(81542001)(76482001)(59766001)(77982001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <89C3BCDD5253D640A2B59ABFEDD1E8D3@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9AG6qO3022151

On Thu, 2013-10-10 at 16:59 +0100, Corentin Chary wrote:

> 
> This doesn't really seems to be related to wmi, and is likely to be
> available only on a subset of models. Maybe it should a separate
> driver instead ?

This version seems to be implemented entirely in WMI, and it's using the
same WMI GUID as asus-wmi - implementing it here seems appropriate. I am
concerned about the phys/virt thing, though. The ACPI interpreter is
running in the kernel, not the hardware - are we artificially limiting
SystemMemory opregions to physical addresses?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
