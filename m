Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaIVR70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:59:26 -0400
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:64083
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754033AbaIVR7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:59:24 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>,
        Jose Rivera <German.Rivera@freescale.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>, "agraf@suse.de" <agraf@suse.de>,
        "linuxppc-release@linux.freescale.net" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus
 driver patch series
Thread-Topic: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus
 driver patch series
Thread-Index: AQHP1FwIp1WtrUAfFkC6MzUdpruiqJwNYr4AgAAK6HA=
Date: Mon, 22 Sep 2014 17:59:21 +0000
Message-ID: <0e13cde24a284873ab6f65f7e5ffdb3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
 <20140922115328.7d6fa30635ed52de425f9ebc@freescale.com>
In-Reply-To: <20140922115328.7d6fa30635ed52de425f9ebc@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0732;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(377454003)(24454002)(51704005)(189002)(199003)(20776003)(81542003)(83072002)(87936001)(85852003)(76576001)(77096002)(81342003)(99396002)(90102001)(66066001)(79102003)(86362001)(106356001)(21056001)(95666004)(77982003)(120916001)(80022003)(99286002)(4396001)(2656002)(64706001)(74502003)(46102003)(74662003)(50986999)(33646002)(92566001)(106116001)(85306004)(74316001)(83322001)(105586002)(19580395003)(76482002)(19580405001)(97736003)(76176999)(54356999)(31966008)(101416001)(107046002)(108616004)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0732;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Monday, September 22, 2014 11:53 AM
> To: Rivera Jose-B46482
> Cc: gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org; Yoder Stuart-B08248; Wood Scott-
> B07421; agraf@suse.de; linuxppc-release@linux.freescale.net
> Subject: Re: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus driver patch series
> 
> On Fri, 19 Sep 2014 17:49:38 -0500
> "J. German Rivera" <German.Rivera@freescale.com> wrote:
> 
> > CHANGE HISTORY
> >
> > Issues pending resolution not addressed by v2:
> > - What to do with Doxygen comments in patch 1
> 
> It's clear they should be removed.
> 
> > - Whether to move or not FSL-specific header files added in include/linux,
> >   by this patch series, to another location
> 
> there wasn't a valid objection against moving them under fsl/ and
> changing them to use dashes instead of underscores, was there?

There was no objection, but here is the observation.  The current
convention seems to be that under include/linux are 'subsystem'
types--
   include/linux/mmc
   include/linux/spi
   include/linux/raid
    etc

There is no other "company" that has an include/linux/[company-name] that I can
see.  Freescale seems to be the only one.   And there is only a single driver
in there.  So it looks like a complete anomaly.

Why is that?

I guess we could try moving our stuff to incluce/linux/fsl and see if there is
any negative feedback on it.

Stuart
