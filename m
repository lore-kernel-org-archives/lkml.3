Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBSXOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:14:24 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.28]:10437 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbaBSXOW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:14:22 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add latest NetVSP versions to auto
 negotiation
Thread-Topic: [PATCH net-next] hyperv: Add latest NetVSP versions to auto
 negotiation
Thread-Index: AQHPLODzxk5FQlrF/EqTMXDv/jSa5Zq9nfAA//+UiJA=
Date: Wed, 19 Feb 2014 23:00:33 +0000
Message-ID: <b31a2c984e7d4ec2aae75ae77a3bdf65@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1392755334-25884-1-git-send-email-haiyangz@microsoft.com>
 <20140219.162312.1711517042878098859.davem@davemloft.net>
In-Reply-To: <20140219.162312.1711517042878098859.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(13464003)(164054003)(377454003)(79102001)(87936001)(47776003)(51856001)(85852003)(74876001)(20776003)(86612001)(83072002)(47446002)(74502001)(74662001)(19580405001)(4396001)(74366001)(50986001)(47736001)(47976001)(63696002)(81686001)(46406003)(81816001)(81542001)(33646001)(56816005)(85306002)(49866001)(66066001)(65816001)(93136001)(80022001)(2656002)(95416001)(59766001)(46102001)(92566001)(54316002)(81342001)(93516002)(54356001)(50466002)(77982001)(90146001)(95666001)(44976005)(31966008)(23726002)(87266001)(94946001)(6806004)(69226001)(19580395003)(83322001)(56776001)(76796001)(76482001)(80976001)(76786001)(94316002)(74706001)(53806001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:BC14FB5E.1C2F4D6A.FBF8017F.C0E19B8D.2020E;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
X-Forefront-PRVS: 012792EC17
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, February 19, 2014 4:23 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add latest NetVSP versions to auto
> negotiation
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 18 Feb 2014 12:28:54 -0800
> 
> > +	u32 ver_list[] = {NVSP_PROTOCOL_VERSION_1,
> NVSP_PROTOCOL_VERSION_2,
> > +		NVSP_PROTOCOL_VERSION_4, NVSP_PROTOCOL_VERSION_5};
> 
> Please put a space after "{" and before "}".
> 
> > +	int i, num_ver = 4; /* number of different NVSP versions */
> > +
> >
> >  	net_device = get_outbound_net_device(device);
> 
> Please delete the extraneous empty line.
> 
> > +	for (i = num_ver - 1; i >= 0; i--)
> > +		if (negotiate_nvsp_ver(device, net_device, init_packet,
> > +			ver_list[i])  == 0) {
> 
> This is not indented properly, "ver_list[i])" should begin precisely after the
> openning parenthesis of the negotiate_nvsp_ver() function call.

I have sent out a new patch with the suggested updates.

Thanks,
- Haiyang
