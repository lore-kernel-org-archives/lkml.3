Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaCFWIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:08:48 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.29]:50069 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbaCFWIq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:08:46 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Brian Wong <draconicpenguin1@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Hyper-V Synthetic Video Frame Buffer Driver may distort top two
 lines of console
Thread-Topic: Hyper-V Synthetic Video Frame Buffer Driver may distort top
 two lines of console
Thread-Index: AQHPOXx2W59dN7iRf0OjrtDg+nS0hZrUjJiAgAAMOICAAABSoIAAA+pg
Date: Thu, 6 Mar 2014 22:08:19 +0000
Message-ID: <129cf9d54a4c4ba68f4f70725299b9c8@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <5318DD7A.2080706@yahoo.com> <5318E311.8000303@yahoo.com>
 <5318ED51.4060400@yahoo.com>
 <366171544ed34d909b113328d2ed2e64@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <366171544ed34d909b113328d2ed2e64@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:131.107.147.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10?=
 =?us-ascii?Q?009001)(13464003)(189002)(199002)(164054003)(24454002)(47917?=
 =?us-ascii?Q?4003)(377454003)(51704005)(46102001)(97186001)(66066001)(336?=
 =?us-ascii?Q?46001)(2656002)(74876001)(87266001)(77982001)(59766001)(6581?=
 =?us-ascii?Q?6001)(80022001)(15395725004)(46406003)(84676001)(74366001)(7?=
 =?us-ascii?Q?4662001)(74502001)(47446002)(23726002)(31966008)(4396001)(54?=
 =?us-ascii?Q?316002)(76796001)(76786001)(56776001)(56816005)(51856001)(90?=
 =?us-ascii?Q?146001)(50986001)(95666003)(74706001)(85306002)(50466002)(92?=
 =?us-ascii?Q?566001)(97336001)(44976005)(93886001)(6806004)(81542001)(818?=
 =?us-ascii?Q?16001)(83322001)(19580395003)(19580405001)(93516002)(4797600?=
 =?us-ascii?Q?1)(95416001)(69226001)(83072002)(93136001)(49866001)(8585200?=
 =?us-ascii?Q?3)(87936001)(94946001)(81342001)(63696002)(54356001)(2077600?=
 =?us-ascii?Q?3)(47776003)(53806001)(79102001)(47736001)(81686001)(1520234?=
 =?us-ascii?Q?5003)(86612001)(80976001)(1511001)(94316002)(76482001)(15975?=
 =?us-ascii?Q?445006)(15519875005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:B?=
 =?us-ascii?Q?LUSR01MB590;H:hybrid.exchange.microsoft.com;FPR:791EC526.2CE?=
 =?us-ascii?Q?385FA.BB6C7B9F.54E2B9DC.201B6;PTR:InfoDomainNonexistent;MX:1?=
 =?us-ascii?Q?;A:1;LANG:en;?=
X-Forefront-PRVS: 0142F22657
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Thursday, March 6, 2014 4:51 PM
> To: Brian Wong; linux-kernel@vger.kernel.org; Haiyang Zhang
> Subject: RE: Hyper-V Synthetic Video Frame Buffer Driver may distort top
> two lines of console
> 
> 
> 
> > -----Original Message-----
> > From: Brian Wong [mailto:draconicpenguin1@yahoo.com]
> > Sent: Friday, March 7, 2014 3:19 AM
> > To: KY Srinivasan; linux-kernel@vger.kernel.org
> > Subject: Re: Hyper-V Synthetic Video Frame Buffer Driver may distort
> > top two lines of console
> >
> > On 3/6/2014 4:05 PM, Brian Wong wrote:
> > > On 3/6/2014 3:41 PM, Brian Wong wrote:
> > >> I've identified another possible bug in the Hyper-V drivers: When
> > >> the Hyper-V Synthetic Video Frame Buffer Driver is built into the
> > >> kernel, and the VM is paused and continued, the top two lines of
> > >> the console may become distorted. See the image at
> http://imgur.com/kIExFP3.
> > >>
> > >> Can someone look into it?
> Haiyang (copied here) will look into it.
> 

It's a known issue. The root cause is not very clear yet.
It doesn't affect system functions. But we will look into it 
further.

Thanks,
- Haiyang

