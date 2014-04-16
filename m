Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025AbaDPUZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:25:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:19666 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbaDPUZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:25:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,874,1389772800"; 
   d="scan'208";a="419976991"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Lu, Aaron" <aaron.lu@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Subject: RE: Info: mapping multiple BARs. Your kernel is fine.
Thread-Topic: Info: mapping multiple BARs. Your kernel is fine.
Thread-Index: AQHPQFbTsRMjm351nUi0BPnn+Nj/O5rowCwAgACNNGCAAGOLAIAARaMA///+KACAKlHEAIAAnJdw
Date: Wed, 16 Apr 2014 20:24:56 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092630128A097@SHSMSX101.ccr.corp.intel.com>
References: <20140224162400.GE16457@pd.tnic>
 <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
In-Reply-To: <20140416190404.GA7070@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3GKPMA6008296



> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Wednesday, April 16, 2014 12:04 PM
> To: Bjorn Helgaas; Rafael J. Wysocki
> Cc: Zhang, Rui; Lu, Aaron; lkml; x86@kernel.org; Linux PCI; ACPI Devel
> Maling List; Yinghai Lu; H. Peter Anvin; Stephane Eranian; Yan, Zheng Z
> Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
> Importance: High
> 
> On Thu, Mar 20, 2014 at 02:48:30PM -0600, Bjorn Helgaas wrote:
> > Right.  Even if we had this long-term solution, we'd still have
> > Stephane's current problem, because the PNP0C02 _CRS is still wrong.
> >
> > We do have a drivers/pnp/quirks.c where we could conceivably adjust
> > the PNP resource if we found the matching PCI device and MCHBAR.
> That
> > should solve Stephane's problem even with the current
> > drivers/pnp/system.c.
> 
> Guys, this still triggers in -rc1. Do we have a fix or something
> testable at least?
> 
Could you please attach the dmesg output after a fresh boot in -rc1?

Thanks,
rui
> Thanks.
> 
> --
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
