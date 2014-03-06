Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaCFVvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:51:44 -0500
Received: from [207.46.163.141] ([207.46.163.141]:10955 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751697AbaCFVvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:51:39 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Brian Wong <draconicpenguin1@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: Hyper-V Synthetic Video Frame Buffer Driver may distort top two
 lines of console
Thread-Topic: Hyper-V Synthetic Video Frame Buffer Driver may distort top
 two lines of console
Thread-Index: AQHPOXx2W59dN7iRf0OjrtDg+nS0hZrUjJiAgAAMOICAAABSoA==
Date: Thu, 6 Mar 2014 21:50:51 +0000
Message-ID: <366171544ed34d909b113328d2ed2e64@BY2PR03MB299.namprd03.prod.outlook.com>
References: <5318DD7A.2080706@yahoo.com> <5318E311.8000303@yahoo.com>
 <5318ED51.4060400@yahoo.com>
In-Reply-To: <5318ED51.4060400@yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.192.117.251]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(51704005)(377454003)(479174003)(24454002)(189002)(13464003)(69226001)(74316001)(80976001)(19580395003)(87936001)(15975445006)(2656002)(51856001)(47736001)(81686001)(49866001)(81816001)(76576001)(85852003)(50986001)(83072002)(54316002)(81542001)(54356001)(53806001)(90146001)(76482001)(4396001)(74706001)(66066001)(93136001)(94316002)(83322001)(95666003)(56816005)(19580405001)(76796001)(74366001)(81342001)(56776001)(86612001)(63696002)(47446002)(74502001)(15202345003)(86362001)(95416001)(74662001)(87266001)(77982001)(59766001)(65816001)(1511001)(31966008)(79102001)(74876001)(15395725003)(93516002)(92566001)(47976001)(33646001)(46102001)(97186001)(85306002)(76786001)(80022001)(94946001)(97336001)(15519875005)(24736002)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB595;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.192.117.251;FPR:F81EC501.24F385EA.9BCC720C.44E639D8.20217;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Brian Wong [mailto:draconicpenguin1@yahoo.com]
> Sent: Friday, March 7, 2014 3:19 AM
> To: KY Srinivasan; linux-kernel@vger.kernel.org
> Subject: Re: Hyper-V Synthetic Video Frame Buffer Driver may distort top
> two lines of console
> 
> On 3/6/2014 4:05 PM, Brian Wong wrote:
> > On 3/6/2014 3:41 PM, Brian Wong wrote:
> >> I've identified another possible bug in the Hyper-V drivers: When the
> >> Hyper-V Synthetic Video Frame Buffer Driver is built into the kernel,
> >> and the VM is paused and continued, the top two lines of the console
> >> may become distorted. See the image at http://imgur.com/kIExFP3.
> >>
> >> Can someone look into it?
Haiyang (copied here) will look into it.

Regards,

K. Y
> >
> > Just to clarify, I can confirm this bug under both the patched Gentoo
> > 3.10.32 kernel and the vanilla 3.13.5 kernel (see the image at
> > http://imgur.com/mYUTzgt). Is the framebuffer somehow getting
> corrupted?
> >
> 
> The problem also reproduces under Kali Linux with kernel 3.12.6, but only on
> virtual consoles that are not hosting a graphical X session. The problem does
> not appear in X.
> 
> --
> Brian Wong
> http://www.fierydragonlord.com
