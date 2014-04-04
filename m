Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaDDIyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:54:09 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:56625
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbaDDIyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:54:05 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "timur@tabi.org" <timur@tabi.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
Thread-Topic: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
Thread-Index: AQHPT9SzoBtFKZIfLEyeDsRSykEKpJsBEOVwgAACugCAABMk8A==
Date: Fri, 4 Apr 2014 08:54:01 +0000
Message-ID: <54e151b197884ceb9ca300d44f852af3@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396595387-4371-1-git-send-email-Guangyu.Chen@freescale.com>
 <9cb53ac6e0e04c01bc0c6ae6a4d42557@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140404074359.GA2599@MrMyself>
In-Reply-To: <20140404074359.GA2599@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(164054003)(199002)(189002)(51704005)(77982001)(4396001)(81542001)(98676001)(59766001)(80976001)(65816001)(95416001)(93136001)(47446002)(63696002)(47736001)(49866001)(79102001)(69226001)(83072002)(74316001)(50986001)(95666003)(80022001)(31966008)(2656002)(92566001)(74662001)(90146001)(56816005)(66066001)(94946001)(33646001)(81342001)(85306002)(93516002)(76796001)(74502001)(76786001)(53806001)(74366001)(20776003)(54316002)(74876001)(56776001)(97186001)(51856001)(54356001)(86362001)(99286001)(97336001)(87266001)(74706001)(83322001)(76576001)(85852003)(81816001)(81686001)(46102001)(47976001)(94316002)(99396002)(87936001)(76482001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB441;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:6FB94832.60221426.29F7934D.C7E6621F.200CC;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Is that possible for you to test those two clock patches for fsl_sai?
> 
> I think most of us are waiting for your reply to it. And I'd really
> like to move on to append clock dividing code into the driver so both
> of vybrid and imx can easily enable the DAI master mode.
> 

Certainly, I will test them later.

Thanks,

