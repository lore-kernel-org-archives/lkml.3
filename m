Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaBNS25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:28:57 -0500
Received: from mail-am1lp0017.outbound.protection.outlook.com ([213.199.154.17]:51764
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751772AbaBNS24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:28:56 -0500
From: Conrad Kostecki <ck@conrad-kostecki.de>
To: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: AW: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
Thread-Topic: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
Thread-Index: AQHPKW68eF3VOEekGkmzriEhDKIWtpq1BpSAgAADxICAAAJuAIAAAOYQgAABUYCAAAGIwA==
Date: Fri, 14 Feb 2014 18:28:52 +0000
Message-ID: <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com>
 <52FE5683.6030708@zytor.com>
 <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com>
 <52FE5BB6.9070405@zytor.com>
 <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.eurprd04.prod.outlook.com>
 <52FE5D91.6060005@zytor.com>
In-Reply-To: <52FE5D91.6060005@zytor.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.218.103.218]
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(24454002)(189002)(199002)(51704005)(377454003)(479174003)(65816001)(54356001)(53806001)(94946001)(63696002)(66066001)(85306002)(33646001)(59766001)(77982001)(83322001)(19580405001)(56776001)(80976001)(94316002)(46102001)(75402002)(74482001)(86362001)(50986001)(74662001)(47976001)(47446002)(93516002)(31966008)(81816001)(51856001)(95416001)(49866001)(47736001)(93136001)(76576001)(76786001)(74366001)(90146001)(69226001)(74876001)(74316001)(2656002)(87266001)(74706001)(87936001)(81542001)(81342001)(76796001)(85852003)(4396001)(56816005)(2201001)(79102001)(81686001)(54316002)(19580395003)(83072002)(92566001)(95666001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB4PR04MB265;H:DB4PR04MB265.eurprd04.prod.outlook.com;CLIP:79.218.103.218;FPR:9F59F232.1EE60611.81D19FA7.14D3EF31.20162;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: conrad-kostecki.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/14/2014 10:13 AM, Conrad Kostecki wrote:
> >>
> >> Does it have DMI?
> >
> > Unfortunately not.
> >
> > # dmidecode 2.12
> > # No SMBIOS nor DMI entry point found, sorry.
> >
> 
> Sigh.  Does anyone have contacts at Soekris who can complain about this
> stuff?

I don't think, that Soekris will fix this. No model of Soekris ever had implemented DMI.
Their BIOS (called comBIOS) is completely written by them. Output is via serial port only.
At least I know, that the technical engineers at Soekris respond on sales@soekris.com.

Maybe the patch could be extended, that HPET would be only enabled if there is no ACPI present?
