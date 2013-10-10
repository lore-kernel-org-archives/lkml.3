Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3JJAEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:04:25 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:33757
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752747Ab3JJAEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:04:24 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Olaf Hering <olaf@aepfle.de>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnZ1ccAgAADeVCAAALBgIAAAGOQgBNVxwCAABSFkA==
Date: Thu, 10 Oct 2013 00:04:09 +0000
Message-ID: <b6228003e8704f819557eda0355da44e@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <20130927151026.GA29416@aepfle.de>
 <418dd0e9b1054189b61770edb57c5b37@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130927153242.GA29462@aepfle.de>
 <778c69f5eae9483a8380755e4692bcaf@SN2PR03MB061.namprd03.prod.outlook.com>
 <5255DD9A.6070600@zytor.com>
In-Reply-To: <5255DD9A.6070600@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-forefront-prvs: 0995196AA2
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(479174003)(377454003)(189002)(199002)(13464003)(24454002)(74706001)(47446002)(79102001)(74502001)(74366001)(33646001)(50986001)(47736001)(47976001)(81816001)(54356001)(76482001)(80976001)(77982001)(59766001)(51856001)(31966008)(74662001)(56776001)(85306002)(81342001)(81686001)(49866001)(54316002)(46102001)(4396001)(53806001)(63696002)(81542001)(19580395003)(65816001)(83072001)(80022001)(69226001)(74876001)(83322001)(19580405001)(74316001)(56816003)(77096001)(76576001)(76786001)(76796001)(15583001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ee43::2;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9A04V9N016456



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Wednesday, October 09, 2013 3:50 PM
> To: KY Srinivasan
> Cc: Olaf Hering; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On 09/27/2013 08:35 AM, KY Srinivasan wrote:
> >
> > Thanks Olaf. Could you submit the patch.
> >
> 
> Haven't heard anything from Olaf... could you fold in the fix and resumbit?

I think Olaf sent the updated patch out; I will dig up the email and resend it.

Regards,

K. Y
> 
> 	-hpa
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
