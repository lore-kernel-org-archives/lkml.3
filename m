Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaDOWdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:33:19 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:32679
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751460AbaDOWdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:33:16 -0400
X-WSS-ID: 0N43FYX-08-3S7-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Kertesz Laszlo <laszlo.kertesz@gmail.com>, Borislav Petkov <bp@alien8.de>
CC: Alex Deucher <alexdeucher@gmail.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: RE: 15-rc1: radeon modesetting fails
Thread-Topic: 15-rc1: radeon modesetting fails
Thread-Index: AQHPWHihIP37Wi43pkSMNlSSm4CgNZsSrFqAgAAsWwCAABBxgIAAQ4cAgAAFRICAAAnugIAAAWWAgAA+GQD//8jRgA==
Date: Tue, 15 Apr 2014 22:32:56 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D03ECB1D65@satlexdag05.amd.com>
References: <20140415070204.GA4806@pd.tnic> <534CFBD7.3070604@amd.com>
 <20140415120740.GA8306@nazgul.tnic>
 <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
 <534D677C.6080407@gmail.com> <20140415172702.GC4826@pd.tnic>
 <534D743B.8010705@gmail.com> <20140415180735.GG4826@pd.tnic>
 <534DA97E.8070505@gmail.com>
In-Reply-To: <534DA97E.8070505@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(13464003)(377454003)(24454002)(51704005)(44976005)(55846006)(81342001)(50466002)(99396002)(79102001)(92566001)(80022001)(76482001)(20776003)(33656001)(2009001)(47776003)(81542001)(54356999)(76176999)(74662001)(4396001)(87936001)(85852003)(92726001)(74502001)(50986999)(84676001)(23676002)(83072002)(2656002)(80976001)(31966008)(77982001)(83322001)(97736001)(46102001)(19580405001)(19580395003)(86362001)(53416003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB121;H:atltwp02.amd.com;FPR:262EF291.8A035C42.BA53B3CF.C76CCB6A.20194;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0182DBBB05
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3FMXSDj030942

> -----Original Message-----
> From: Kertesz Laszlo [mailto:laszlo.kertesz@gmail.com]
> Sent: Tuesday, April 15, 2014 5:50 PM
> To: Borislav Petkov
> Cc: Alex Deucher; Deucher, Alexander; Koenig, Christian; Maling list - DRI
> developers; lkml
> Subject: Re: 15-rc1: radeon modesetting fails
> 
> Borislav Petkov wrote:
> > On Tue, Apr 15, 2014 at 09:02:35PM +0300, Kertesz Laszlo wrote:
> >> Honestly didnt try that but i assume yes, since the screens go black
> >> when it should change resolution.
> >
> > Pls try it and let us know whether you see the machine booting further,
> > albeit without modesetting.
> >
> > Thanks.
> >
> 
> Yes, it is working that way. But no X, i assume this is expected.

Turning off modesetting basically disables the driver.

Alex

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
