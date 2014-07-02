Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250AbaGBBKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:10:06 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:18563
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754109AbaGBBKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:10:04 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?iso-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 07/12] usb: chipidea: add a generic driver
Thread-Topic: [PATCH v2 07/12] usb: chipidea: add a generic driver
Thread-Index: AQHPj5gGro5Azx09/0KP9YJxwV2nm5uE1bQAgATayoCAATsoAIAACZ2AgAB+/YD//579AIAATQ2AgACksFA=
Date: Wed, 2 Jul 2014 01:10:00 +0000
Message-ID: <1d01427f91084d67bf63721e2267e160@BL2PR03MB226.namprd03.prod.outlook.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140627032506.GA18039@shlinux1.ap.freescale.net>
 <20140630133313.GA11880@kwain>
 <20140701002112.GA26146@shlinux1.ap.freescale.net>
 <53B27789.3090509@gmail.com>
 <20140701083007.GB26146@shlinux1.ap.freescale.net>
 <20140701104254.GD3427@piout.net> <53B2D151.60404@cogentembedded.com>
In-Reply-To: <53B2D151.60404@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(479174003)(377454003)(24454002)(189002)(199002)(51704005)(21056001)(95666004)(81542001)(106116001)(74316001)(107046002)(85306003)(106356001)(77096002)(101416001)(81342001)(92566001)(105586002)(33646001)(87936001)(77982001)(83072002)(85852003)(79102001)(2656002)(66066001)(83322001)(46102001)(80022001)(76176999)(74662001)(4396001)(64706001)(76482001)(93886003)(99396002)(54356999)(76576001)(31966008)(86362001)(74502001)(20776003)(50986999)(108616002)(41533002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB228;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> Hello.
> 
> On 07/01/2014 02:42 PM, Alexandre Belloni wrote:
> 
> >>>>> Well, there is nothing specific about the Berlin CI. Some
> >>>>> subsystems use the 'generic' keyword in these cases. Do you see a
> >>>>> particular reason I should use some Berlin related compatible here?
> 
> >>>> Not must, one suggestion is: can you change the compatible string
> >>>> to "chipidea-usb-generic"?
> 
> >>> I don't know about ChipIdea/ARC/DW's product portfolio but I guess
> >>> the compatible should also carry '2.0' or 'usb2' in it. Or we just
> >>> use some version number like 'chipidea,ci13000' or 'chipidea,ci13xxx'.
> 
> >> The recommended format for compatible string is:
> >> "manufacturer,model", I agree with "chipidea,ci13xxx", thanks.
> 
> > I think we should probably avoid using wildcards in the compatible
> > string.
> 
>     I'm sure wildcards shouldn't be allowed there. :-)

Then, what's your guys recommend, how about "chipidea,usb2-generic"?

Peter

