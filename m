Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaIVO5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:57:36 -0400
Received: from mail-bn1bbn0107.outbound.protection.outlook.com ([157.56.111.107]:48206
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753486AbaIVO5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:57:35 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>
CC: Alexander Graf <agraf@suse.de>, Jose Rivera <German.Rivera@freescale.com>,
        Kim Phillips <Kim.Phillips@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAC1K8CAATKJoIAALEQAgARKFxA=
Date: Mon, 22 Sep 2014 14:42:10 +0000
Message-ID: <de1164ab115042aa9a2a9cafcc01ef1d@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	<a7c8cfc9520d49749f10c78e05b09cd5@CY1PR0301MB0748.namprd03.prod.outlook.com>
 <20140919155802.d5d8e80c7aff3b2ae81c6b50@freescale.com>
In-Reply-To: <20140919155802.d5d8e80c7aff3b2ae81c6b50@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0730;UriScan:;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377454003)(189002)(13464003)(199003)(24454002)(110136001)(86362001)(93886004)(19580395003)(76576001)(2656002)(90102001)(108616004)(83322001)(76482002)(92566001)(85306004)(19580405001)(31966008)(120916001)(33646002)(87936001)(74316001)(77096002)(97736003)(99286002)(105586002)(101416001)(95666004)(106116001)(106356001)(66066001)(46102003)(54356999)(83072002)(77982003)(74502003)(50986999)(4396001)(81542003)(20776003)(107046002)(85852003)(64706001)(81342003)(79102003)(99396002)(76176999)(21056001)(80022003)(74662003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0730;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Friday, September 19, 2014 3:58 PM
> To: Yoder Stuart-B08248
> Cc: Alexander Graf; Rivera Jose-B46482; Phillips Kim-R1AAHA; <gregkh@linuxfoundation.org>; <arnd@arndb.de>;
> <linux-kernel@vger.kernel.org>; Wood Scott-B07421; <linuxppc-release@linux.freescale.net>
> Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> 
> On Fri, 19 Sep 2014 13:25:06 -0500
> Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:
> 
> > > From: Yoder Stuart-B08248
> > > Sent: Thursday, September 18, 2014 7:19 PM
> > >
> > > +/**
> > > > >>> + * @brief    Disconnects one endpoint to remove its network link
> > > > >>> + *
> > > > >>> + * @param[in]   mc_io        Pointer to opaque I/O object
> > > > >>> + * @param[in]    dprc_handle    Handle to the DPRC object
> > > > >>> + * @param[in]   endpoint    Endpoint configuration parameters.
> > > > >>> + *
> > > > >>> + * @returns    '0' on Success; Error code otherwise.
> > > > >>> + * */
> > > > >>> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
> > > > >>> +            struct dprc_endpoint *endpoint);
> > > > >>> +
> > > > >>> +/*! @} */
> > > > >>
> > > > >> this entire file is riddled with non-kernel-doc comment markers:  see
> > > > >> Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
> > > > >> other types of comments in a kernel-doc compliant format.
> > > > > This is because this file is using doxygen comments, as it was developed
> > > > > by another team. Unless someone else has an objection, I will leave the doxygen comments alone and
> not
> > > make
> > > > any change here.
> > > >
> > > > Do you see any other source files in Linux using doxygen comments?
> > >
> > > Yes.  Grep around a bit and you'll see examples of it.  I grep'ed for some
> > > doxygen tags and found close to 200 source files with them.
> 
> grepping for the one in this patch above - "! @}" - returns nothing.
> 
> > > > Mixing different documentation styles can
> > > > easily become a big mess, because you can't generate external documentation consistently for the whole
> > > tree.
> > >
> > > As German mentioned elsewhere, this file is an interface to a hardware block,
> > > was written by another team targetting a wide variety of environments-- u-boot,
> > > Linux, user space, other OSes etc.
> > >
> > > We left the doxygen stuff there because while admitedly not used much, there
> > > are other examples of it in the kernel and the documentation seems useful.
> > > If it can't go into the kernel as is, we can just delete it.
> >
> > ...to be clear, we could just delete the doyxen tags.  There is no scenario
> > where I would envision anyone generating documentation from these files in
> > the kernel.  The tags are there because of where we grabbed the source from.
> > It certainly would benefit no one by conversion to kerneldoc.
> 
> except kerneldoc users :)
> 
> > However, just leaving the comments and doxygen tags alone as is would be nice.
> 
> they are incompatible with kerneldoc.

Seriously, no one is going to ever generate docs from this obscure bit of code
documenting an internal interface within this driver.  Makes no sense to convert
the comments to kerneldoc.

I completely get what you are saying with respect to comments actually documenting
kernel interfaces used by different kernel components or uapi interfaces.

The doxygen tags are there because this code originated in a different project. That
code was intended to be Linux-style compliant and complies with checkpatch --strict.
However, we can sanitize the code and remove the tags if they are causing grief.
It's too bad though, because we'll have to fork this interface code from its origin.

Stuart



