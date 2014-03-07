Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaCGDI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:08:57 -0500
Received: from relmlor4.renesas.com ([210.160.252.174]:62980 "EHLO
	relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753077AbaCGDIw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:08:52 -0500
X-IronPort-AV: E=Sophos;i="4.97,605,1389711600"; 
   d="scan'208";a="155862729"
From: YOSHIYUKI ITO <yoshiyuki.ito.ub@renesas.com>
To: Jason Cooper <jason@lakedaemon.net>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: RE: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
Thread-Topic: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
Thread-Index: AQHPMTzFRmSi/sfahkSa3s34+JMJZprEtOWAgAEC3QCAAPPaAIAAoGWAgABWnYCADUOGAIAADeaAgAANdumAAAAN4A==
Date: Fri, 7 Mar 2014 03:08:36 +0000
Message-ID: <2376200c835b48d5b0c39d0186877fca@SIXPR06MB144.apcprd06.prod.outlook.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224181023.GA1010@titan.lakedaemon.net>
 <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
 <20140226000940.GF1872@titan.lakedaemon.net>
 <CACRpkdYQa2BG_qxf5zY=7rks6O31ZF-BX0af3_u1MOgwfwxFSQ@mail.gmail.com>
 <20140226145345.GG1872@titan.lakedaemon.net>
 <CACRpkdZRJG-TzN4c3NSH9PqcQzpo6EbEn5_bM-P3sh4_vSjtaA@mail.gmail.com>
 <20140307021633.GN1872@titan.lakedaemon.net>
 <20140307.115709.525573020409548427.yoshiyuki.ito.ub@renesas.com>
 <20140307030359.GO1872@titan.lakedaemon.net>
In-Reply-To: <20140307030359.GO1872@titan.lakedaemon.net>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [211.11.155.138]
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(24454002)(189002)(199002)(13464003)(377454003)(76576001)(85852003)(54356001)(74706001)(19580395003)(76796001)(66066001)(95416001)(77096001)(87266001)(76482001)(49866001)(83322001)(74502001)(76786001)(74876001)(87936001)(97186001)(90146001)(33646001)(80022001)(19580405001)(83072002)(97336001)(80976001)(81686001)(56816005)(65816001)(94946001)(85306002)(47446002)(77982001)(81342001)(59766001)(63696002)(31966008)(74662001)(94316002)(47976001)(92566001)(79102001)(4396001)(47736001)(53806001)(81816001)(95666003)(54316002)(81542001)(56776001)(50986001)(74366001)(51856001)(69226001)(46102001)(93136001)(2656002)(93516002)(86362001)(74316001)(129583001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:SIXPR06MB112;H:SIXPR06MB144.apcprd06.prod.outlook.com;CLIP:211.11.155.138;FPR:9ECEF342.B8DEBE0B.82E19754.50E4EBF8.2020F;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jason and all other recipients,

   I'm sorry to my mis operation.. Please ignore my odd mail last I sent.
I have to check my mailer.

Regards,
Yoshiyuki Ito.

-----Original Message-----
From: Jason Cooper [mailto:jason@lakedaemon.net] 
Sent: Friday, March 07, 2014 12:04 PM
To: YOSHIYUKI ITO
Cc: linus.walleij@linaro.org; mark.rutland@arm.com; andrew@lunn.ch; linux@arm.linux.org.uk; pawel.moll@arm.com; linux-doc@vger.kernel.org; ijc+devicetree@hellion.org.uk; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; robh+dt@kernel.org; rob@landley.net; galak@codeaurora.org; gregory.clement@free-electrons.com; linux-arm-kernel@lists.infradead.org; sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from Dove pinctrl

Yoshiyuki,

Umm, I'm pretty sure you didn't send this to who you thought you did. :)

thx,

Jason.

On Fri, Mar 07, 2014 at 11:57:09AM +0900, Yoshiyuki Ito wrote:
> 
> ... something which might have been private but I don't speak Japanese
> (?) ...
