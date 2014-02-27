Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaB0CwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:52:05 -0500
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:43307
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752607AbaB0CwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:52:03 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv9 Resend 4/4] Documentation: Add device tree bindings
 for Freescale FTM PWM.
Thread-Topic: [PATCHv9 Resend 4/4] Documentation: Add device tree bindings
 for Freescale FTM PWM.
Thread-Index: AQHPLVcPXex5a4kF5k2kaQ0bKfIp0JrHjoYAgADkRJA=
Date: Thu, 27 Feb 2014 02:52:00 +0000
Message-ID: <ece53a62591545b7a22310694e2b15ed@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392799137-17188-1-git-send-email-Li.Xiubo@freescale.com>
 <1392799137-17188-5-git-send-email-Li.Xiubo@freescale.com>
 <20140226131355.GB29779@ulmo.nvidia.com>
In-Reply-To: <20140226131355.GB29779@ulmo.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(66066001)(69226001)(80022001)(81342001)(65816001)(56816005)(76786001)(90146001)(93136001)(76796001)(63696002)(47976001)(47736001)(50986001)(77982001)(49866001)(76576001)(95666003)(93516002)(56776001)(4396001)(74876001)(74706001)(94316002)(46102001)(53806001)(85306002)(54356001)(47446002)(92566001)(86362001)(76482001)(95416001)(74502001)(31966008)(94946001)(74662001)(54316002)(85852003)(83322001)(87266001)(2656002)(59766001)(87936001)(79102001)(33646001)(19580395003)(74366001)(51856001)(81816001)(81542001)(80976001)(81686001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB425;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:E3F0CEDF.2F9124AB.B958B102.80A7EE1D.200CC;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> >
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> [...]
> > +- clocks : Must contain a clock specifier for each entry in clock-names,
> 
> Nit: A slightly more correct way to say this would be: "Must contain a
> phandle and clock specifier...".
> 

Yes, I will fix this.

Thanks very much,

--
Best Regards,
Xiubo

