Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaBNSN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:13:29 -0500
Received: from mail-am1lp0015.outbound.protection.outlook.com ([213.199.154.15]:42812
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbaBNSN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:13:28 -0500
From: Conrad Kostecki <ck@conrad-kostecki.de>
To: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
Thread-Topic: AW: [PATCH] x86: HPET force enable for Soekris net6501
Thread-Index: AQHPKW68eF3VOEekGkmzriEhDKIWtpq1BpSAgAADxICAAAJuAIAAAOYQ
Date: Fri, 14 Feb 2014 18:13:24 +0000
Message-ID: <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.eurprd04.prod.outlook.com>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com>
 <52FE5683.6030708@zytor.com>
 <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com>
 <52FE5BB6.9070405@zytor.com>
In-Reply-To: <52FE5BB6.9070405@zytor.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.218.103.218]
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(377454003)(189002)(199002)(51704005)(479174003)(24454002)(243025003)(87936001)(87266001)(2656002)(74706001)(81342001)(81542001)(76796001)(76576001)(74366001)(90146001)(76786001)(15202345003)(93136001)(74876001)(74316001)(69226001)(95666001)(92566001)(81686001)(79102001)(56816005)(2201001)(4396001)(85852003)(83072002)(54316002)(19580395003)(56776001)(80976001)(77982001)(59766001)(83322001)(65816001)(85306002)(33646001)(94946001)(53806001)(66066001)(63696002)(54356001)(15975445006)(51856001)(81816001)(49866001)(47736001)(95416001)(94316002)(46102001)(47446002)(47976001)(74662001)(31966008)(93516002)(50986001)(75402002)(74482001)(86362001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB4PR04MB266;H:DB4PR04MB265.eurprd04.prod.outlook.com;CLIP:79.218.103.218;FPR:BD59E50C.AFF28610.FEA25E8.4CC82748.201BD;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: conrad-kostecki.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/14/2014 10:06 AM, Conrad Kostecki wrote:
> >
> > Hm. I am not. The Soekris is my only device with an E6xx CPU. This one is
> special, as Soekris does not implement ACPI.
> > I don't know, how other E6xx systems do work. I guess, there will have
> ACPI. There seem not to be many out there.
> > This patch is now running for about six months without any problems for
> me.
> >
> > I was also searching for some other systems. I found here only one manual.
> > There are at least the same vendor/device id shown, as used also in
> Soekris.
> > -> http://www.ekf.de/p/pc2/pc2_ug.pdf
> >
> > Is there maybe any possibility to check for the specific Soekris model? At
> least MPTABLE identifies the Soekris:
> > [    0.000000] MPTABLE: OEM ID: Soekris
> > [    0.000000] MPTABLE: Product ID: net6501
> > [    0.000000] MPTABLE: APIC at: 0xFEE00000
> >
> 
> Does it have DMI?

Unfortunately not.

# dmidecode 2.12
# No SMBIOS nor DMI entry point found, sorry.

Cheers
Conrad
