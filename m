Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaCLDNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:13:51 -0400
Received: from mail-bn14138.inbound.protection.outlook.com ([207.46.163.138]:44344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752616AbaCLDNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:13:50 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 resend 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Topic: [PATCHv3 resend 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Index: AQHPPO34b2reQlDF806EJu/ESa6on5rbp7yAgAEetNA=
Date: Wed, 12 Mar 2014 03:12:06 +0000
Message-ID: <9988b8fc5b404b5796ef51a51fd5aa9d@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1394513002-21946-1-git-send-email-Li.Xiubo@freescale.com>
 <1394513002-21946-2-git-send-email-Li.Xiubo@freescale.com>
 <20140311100057.GK28112@sirena.org.uk>
In-Reply-To: <20140311100057.GK28112@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(24454002)(164054003)(93136001)(46102001)(93516002)(74366001)(56776001)(74706001)(47736001)(77982001)(59766001)(76482001)(69226001)(86362001)(31966008)(85306002)(49866001)(74876001)(74502001)(47976001)(97336001)(74316001)(54316002)(33646001)(81542001)(74662001)(47446002)(76796001)(56816005)(90146001)(94946001)(65816001)(80022001)(83322001)(94316002)(20776003)(76786001)(53806001)(85852003)(83072002)(63696002)(2656002)(92566001)(4396001)(76576001)(54356001)(95666003)(81342001)(95416001)(81816001)(50986001)(79102001)(87936001)(97186001)(80976001)(51856001)(87266001)(66066001)(81686001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB027;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:FBF8617C.9D12ECA9.BC6391C6.40EDF930.2010C;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv3 resend 1/3] ASoC: codec: Simplify ASoC probe code.
> 
> On Tue, Mar 11, 2014 at 12:43:20PM +0800, Xiubo Li wrote:
> > For some CODEC drivers like who act as the MFDs children are ignored
> > by this patch.
> 
> Applied all, thanks.  I'd generally recommend about putting things like
> "resend" in the subject, it can make the prefix awfully long and hide
> the actual subject.

Yes, I will follow this.

Thanks,

--
Best Regards,
Xiubo
