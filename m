Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3I0Pf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:35:26 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:4233
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753756Ab3I0PfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:35:03 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnZ1ccAgAADeVCAAALBgIAAAGOQ
Date: Fri, 27 Sep 2013 15:35:00 +0000
Message-ID: <778c69f5eae9483a8380755e4692bcaf@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <20130927151026.GA29416@aepfle.de>
 <418dd0e9b1054189b61770edb57c5b37@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130927153242.GA29462@aepfle.de>
In-Reply-To: <20130927153242.GA29462@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.238.85.242]
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(199002)(24454002)(377454003)(189002)(13464003)(63696002)(74706001)(65816001)(59766001)(69226001)(79102001)(77982001)(80022001)(74316001)(74366001)(81342001)(83072001)(56816003)(54356001)(81542001)(54316002)(76482001)(77096001)(81816001)(50986001)(4396001)(47446002)(47736001)(74502001)(19580405001)(47976001)(83322001)(46102001)(49866001)(80976001)(51856001)(33646001)(74662001)(74876001)(19580395003)(31966008)(66066001)(76796001)(76786001)(56776001)(53806001)(76576001)(81686001)(24736002)(15583001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:212.238.85.242;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8RFZUBL024476



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, September 27, 2013 8:33 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com;
> tglx@linutronix.de; hpa@zytor.com; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On Fri, Sep 27, KY Srinivasan wrote:
> 
> > > This leads to build errors on 32bit:
> > >
> > > linux-3.12-rc2/arch/x86/kernel/cpu/mshyperv.c:88: undefined reference to
> > > `__udivdi3'
> > >
> > > Up to now I have only tested on 64bit, sorry for that.
> >
> > Thanks Olaf. I am travelling currently; I will fix it when I get back (early next
> week).
> 
> This change seems to fix it:
> 
> -+              hv_lapic_frequency /= HZ;
> ++              div_u64(hv_lapic_frequency, HZ);

Thanks Olaf. Could you submit the patch.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
