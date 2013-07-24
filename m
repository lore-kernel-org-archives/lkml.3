Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3GXPDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:03:19 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:10097
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab3GXPDS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:03:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI9371I542I1432Idbb0idbf2izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1d7338h1de098h17326ah8275dh1de097h1de096h1d68deh8275bhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MQG4H8-02-2YA-02
X-M-MSG: 
From: "Hurwitz, Sherry" <sherry.hurwitz@amd.com>
To: Marc Dietrich <marvin24@gmx.de>
CC: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] linux-firmware/AMD: add readme files for amd-ucode
Thread-Topic: [PATCH] linux-firmware/AMD: add readme files for amd-ucode
Thread-Index: AQHOhNF7p/P4/SdX30CxkUXqo4zX/5ltpW4AgAZNuuA=
Date: Wed, 24 Jul 2013 15:03:07 +0000
Message-ID: <ACC57DAD9FA29445AB3FF28B6500CF4E60B03D19@sausexdag01.amd.com>
References: <1374273832-5228-1-git-send-email-sherry.hurwitz@amd.com>
 <1581606.2MIpuxPjZY@ax5200p>
In-Reply-To: <1581606.2MIpuxPjZY@ax5200p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.48.54]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this site is down for the moment but we are working to get it back up as an informational site.  It will not be used as the primary distribution site for the ucode.  We want to direct people to the linux-firmware tree. 

> -----Original Message-----
> From: Marc Dietrich [mailto:marvin24@gmx.de]
> Sent: Saturday, July 20, 2013 4:44 AM
> To: Hurwitz, Sherry
> Cc: David Woodhouse; Ben Hutchings; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] linux-firmware/AMD: add readme files for amd-ucode
> 
> On Friday 19 July 2013 17:43:52 Sherry Hurwitz wrote:
> > File: README
> > File: microcode_amd.bin.README
> > File: microcode_amd_fam15h.bin.README
> >
> > Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
> > ---
> >  amd-ucode/README                          |   46
> > +++++++++++++++++++++++++++++ amd-ucode/microcode_amd.bin.README
> |
> > 29 ++++++++++++++++++ amd-ucode/microcode_amd_fam15h.bin.README |
> 13
> > ++++++++
> >  3 files changed, 88 insertions(+)
> >  create mode 100644 amd-ucode/README
> >  create mode 100644 amd-ucode/microcode_amd.bin.README
> >  create mode 100644 amd-ucode/microcode_amd_fam15h.bin.README
> >
> > diff --git a/amd-ucode/README b/amd-ucode/README new file mode
> 100644
> > index 0000000..a92831d
> > --- /dev/null
> > +++ b/amd-ucode/README
> > @@ -0,0 +1,46 @@
> > +This package provides latest microcode patches for AMD processor
> > +families >= 0x10.
> > +
> > +See http://www.amd64.org/support/microcode.html
> > +for details.
> 
> Wasn't this URL deprecated (at least it's offline now)?
> 
> Marc
> 


