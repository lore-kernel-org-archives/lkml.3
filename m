Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3G2XtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:49:10 -0400
Received: from ozlabs.org ([203.10.76.45]:45280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3G2XtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:49:08 -0400
Date: Tue, 30 Jul 2013 09:49:22 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130729234922.GI29970@voom.fritz.box>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F39FD8.6080808@broadcom.com>
 <20130727183059.GD4813@netboy>
 <1441731.8CGUI1tUxh@flatron>
 <20130729180513.GB1884@obsidianresearch.com>
 <20130729222039.GE29970@voom.fritz.box>
 <20130729231425.GA4439@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gJNQRAHI5jiYqw2y"
Content-Disposition: inline
In-Reply-To: <20130729231425.GA4439@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gJNQRAHI5jiYqw2y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 05:14:25PM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 30, 2013 at 08:20:39AM +1000, David Gibson wrote:
>=20
> > > Clearly general purpose systems (eg servers, workstations, etc) with
> > > *full featured firmware* fall into category b. Linux already basically
> > > has stable DT for those systems - but the firmware is expected to do
> > > lots of work and hide all the low level details from the
> > > kernel.  Basically, the DT should stick to approximately ePAR and
> > > everything else is hidden by the firmware.
> >=20
> > No.  With the exception of the hypervisor/virtualization extensions,
> > ePAPR describes (for now) an entirely passive firmware interface.
> > That is, once the handover to the OS has happened, there is *no*
> > further firmware interaction.  It is not capable of hiding any details
> > from the OS, except those which can be done by one-time
> > initialization.
>=20
> Well, one-time initialization details are actually exactly one of the
> areas I am thinking about. Some of the embedded SOCs have extensive
> one time initization code in the kernel that is highly SOC specific
> and on x86 it would live in the firmware.
>=20
> But I see what you mean, ePAPR was the wrong reference, I didn't
> carefully check it. I ment the kind of DT use we've seen in SPARC,
> POWER servers, Apple stuff, etc - systems explicitly designed so that
> new hardware will boot old OSs.

Yeah, and at least for POWER servers and Apples, like every other
attempt at this, ever, it at best sorta-kinda worked.  It's not *as*
bad as the mess of broken BIOSes on x86 (mostly due to smaller
variety), but there's still plenty of broken crap in Apple workstation
and IBM server firmwares and device trees.

You see a clear line between "full featured" and "minimal" firmwares
where none exists.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--gJNQRAHI5jiYqw2y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlH2/4IACgkQaILKxv3ab8ZtgACfYz6bT3m2hNvuxUWUhb3IIUpQ
Kj8AnjpqL6TNgJck/mJt/EA022/rbkGP
=TF6H
-----END PGP SIGNATURE-----

--gJNQRAHI5jiYqw2y--
