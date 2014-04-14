Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaDNRKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:10:07 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:47865
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753877AbaDNRKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:10:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: RE: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Topic: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Index: AQHPWAHNedkd2X2EdkGHQBwaY8oyvZsRWCwAgAAAaXA=
Date: Mon, 14 Apr 2014 17:09:49 +0000
Message-ID: <666b84109e704ababfebc8232238623f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1397497584-23717-1-git-send-email-kys@microsoft.com>
 <534C15F2.105@zytor.com>
In-Reply-To: <534C15F2.105@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ee31::3]
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(13464003)(199002)(189002)(479174003)(377454003)(24454002)(33646001)(77982001)(83322001)(92566001)(86362001)(85852003)(76576001)(79102001)(81342001)(76482001)(54356999)(50986999)(80022001)(76176999)(77096999)(80976001)(86612001)(83072002)(19580405001)(99396002)(74316001)(74662001)(74502001)(31966008)(46102001)(99286001)(20776003)(4396001)(87936001)(2656002)(81542001)(19580395003)(1121002)(921003)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:8E1EE522.98BE6D02.34FBC3BF.CB618BBB.2016B;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Monday, April 14, 2014 10:08 AM
> To: KY Srinivasan; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> JBeulich@suse.com
> Subject: Re: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic
> appropriately
> 
> On 04/14/2014 10:46 AM, K. Y. Srinivasan wrote:
> > +	new_val = inb(PIC_MASTER_IMR);
> > +	if (probe_val != new_val) {
> 
> Nitpick: Linux coding style should have this as:
> 
> 	if (new_val != probe_val)
> 
> 	-hpa
> 
Will address this as well.

K. Y
