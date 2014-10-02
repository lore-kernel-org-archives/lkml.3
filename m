Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaJBOlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:41:31 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:11820 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaJBOla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:41:30 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Scott.Benesh@pmcs.com" <Scott.Benesh@pmcs.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "crope@iki.fi" <crope@iki.fi>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ISS StorageDev <iss_storagedev@hp.com>
Subject: RE: [PATCH] MAINTAINERS: fix Mike Miller's e-mail address
Thread-Topic: [PATCH] MAINTAINERS: fix Mike Miller's e-mail address
Thread-Index: AQHP3g84LrUuIpcNYUGugkdR/AOHH5wcZaYAgAB5vOA=
Date: Thu, 2 Oct 2014 14:40:45 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCA5A9@G4W3202.americas.hpqcorp.net>
References: <1412233478-17115-1-git-send-email-michael.opdenacker@free-electrons.com>
 <542CFBF8.6080703@free-electrons.com>
In-Reply-To: <542CFBF8.6080703@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michael Opdenacker [mailto:michael.opdenacker@free-electrons.com]
> Sent: Thursday, 02 October, 2014 2:17 AM
> To: akpm@linux-foundation.org
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; joe@perches.com;
> m.chehab@samsung.com; crope@iki.fi; jg1.han@samsung.com; linux-
> kernel@vger.kernel.org; mikem@beardog.cce.hp.com; ISS StorageDev
> Subject: Re: [PATCH] MAINTAINERS: fix Mike Miller's e-mail address
> 
> On 10/02/2014 09:04 AM, Michael Opdenacker wrote:
> > This replaces Mike Miller's e-mail address
> > (now rejected by the HP mail server) by the
> > latest one that he used to submit patches.
> >
> > Checked that this one is not rejected.
> >
> > Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> > ---
> >  MAINTAINERS | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 37054306dc9f..6a8677b5ba24 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4230,7 +4230,7 @@ F:	include/linux/cciss*.h
> >  F:	include/uapi/linux/cciss*.h
> >
> >  HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
> > -M:	Mike Miller <mike.miller@hp.com>
> > +M:	Mike Miller <mikem@beardog.cce.hp.com>
> >  L:	iss_storagedev@hp.com
> >  S:	Supported
> >  F:	Documentation/blockdev/cciss.txt
> 
> Oops, copying Mike Miller and the corresponding list too... Blind trust
> in get_maintainer.pl is evil ;)
> 
> Michael.
> 
> --
> Michael Opdenacker, CEO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
> +33 484 258 098

NAK - Mike Miller is not at HP any more.  The beardog machine is still
here but the email accounts are not monitored.

PMC-Sierra (copying Scott Benesh) will be picking up maintenance of
hpsa and maybe cciss.  cpqarray should probably be marked unmaintained
or removed from the kernel.

---
Rob Elliott    HP Server Storage




