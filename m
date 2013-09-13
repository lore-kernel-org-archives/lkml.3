Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3IMBnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:43:16 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:32971
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754414Ab3IMBnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:43:13 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnC17CggAAG+ACAABQ5UA==
Date: Fri, 13 Sep 2013 01:43:09 +0000
Message-ID: <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
In-Reply-To: <52325C1E.90101@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 0968D37274
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(479174003)(24454002)(13464003)(51704005)(199002)(189002)(77982001)(81686001)(81816001)(59766001)(77096001)(80976001)(56816003)(76786001)(50986001)(76796001)(63696002)(76576001)(65816001)(79102001)(54356001)(74366001)(74316001)(76482001)(33646001)(83322001)(19580395003)(19580405001)(46102001)(83072001)(47446002)(74662001)(51856001)(31966008)(74502001)(49866001)(47976001)(56776001)(47736001)(4396001)(54316002)(74876001)(81342001)(81542001)(69226001)(66066001)(80022001)(53806001)(74706001)(24736002)(15583001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Thursday, September 12, 2013 5:28 PM
> To: KY Srinivasan
> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On 09/12/2013 05:06 PM, KY Srinivasan wrote:
> >
> > Peter,
> >
> > Let me know if you want me to address any additional issues in this patch.
> >
> 
> Please address Jan and Gleb's feedback.

Gleb's feedback was a question and I answered that as I did Jan's feedback as well.
Gleb, Jan, please let me know if there is something else you want addressed here.

Regards,

K. Y

