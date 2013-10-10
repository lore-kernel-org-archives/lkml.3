Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3JJPZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:25:16 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:1766 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317Ab3JJPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:25:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Topic: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Index: AQHOvtVzBV4rU1waRU2d31z3B2ehfZngRDQAgAAiCgCAAECXgIAAC74AgADT3ICAADVkAIAAAgwAgAADCQCAAB/ggIAACLGAgAACMICAAAU8gIAAIuWAgAE8pICAAAXnAIAABMAAgAAWmACACVTWgIAABWmAgAAGVwCAAAVEgIAAkmlwgACxsYCAAABk4A==
Date: Thu, 10 Oct 2013 15:25:07 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D071AFD08@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox> <20131002203735.GA10871@kroah.com>
	 <1380748121.12932.89.camel@snotra.buserror.net>
	 <20131002211631.GA11914@kroah.com>
	 <1380749715.12932.109.camel@snotra.buserror.net>
	 <20131002234009.GA27714@kroah.com>
	 <1380825207.12932.151.camel@snotra.buserror.net>
	 <20131003185434.GA26123@kroah.com>
	 <1380827494.12932.161.camel@snotra.buserror.net>
	 <20131003203226.GB27336@kroah.com>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
	 <1381346507.7979.334.camel@snotra.buserror.net>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDAB4@039-SN1MPN1-002.039d.mgd.msft.net>
	 <1381348999.7979.360.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071AEE4C@039-SN2MPN1-012.039d.mgd.msft.net>
 <1381418599.7979.401.camel@snotra.buserror.net>
In-Reply-To: <1381418599.7979.401.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.195.143]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9AFPTWv021284



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Thursday, October 10, 2013 8:53 PM
> To: Bhushan Bharat-R65777
> Cc: Wood Scott-B07421; Yoder Stuart-B08248; Kim Phillips; Christoffer Dall; Alex
> Williamson; linux-kernel@vger.kernel.org; a.motakis@virtualopensystems.com;
> agraf@suse.de; Sethi Varun-B16395; peter.maydell@linaro.org;
> santosh.shukla@linaro.org; kvm@vger.kernel.org; gregkh@linuxfoundation.org
> Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
> 
> On Thu, 2013-10-10 at 02:45 -0500, Bhushan Bharat-R65777 wrote:
> >
> > > -----Original Message-----
> > > From: Wood Scott-B07421
> > > Sent: Thursday, October 10, 2013 1:33 AM
> > > To: Yoder Stuart-B08248
> > > Cc: Wood Scott-B07421; Kim Phillips; Christoffer Dall; Alex
> > > Williamson; linux- kernel@vger.kernel.org;
> > > a.motakis@virtualopensystems.com; agraf@suse.de; Sethi Varun-B16395;
> > > Bhushan Bharat-R65777; peter.maydell@linaro.org;
> > > santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > > gregkh@linuxfoundation.org
> > > Subject: Re: RFC: (re-)binding the VFIO platform driver to a
> > > platform device
> > >
> > > On Wed, 2013-10-09 at 14:44 -0500, Yoder Stuart-B08248 wrote:
> > > > Ah, think I understand now...yes that works as well, and would be
> > > > less intrustive.   So are you writing a patch? :)
> > >
> > > I've been meaning to since the previous round of discussion, but I've been
> busy.
> > > Would someone else be able to test it in the context of using it for VFIO?
> >
> > I wish I could have but I do not have vfio-platform stuff.
> 
> VFIO PCI without new_id would also be a useful test.

I will do that :)

-Bharat

> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
