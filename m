Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3G1V6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 17:58:06 -0400
Received: from ozlabs.org ([203.10.76.45]:42556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab3G1V6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 17:58:02 -0400
Date: Mon, 29 Jul 2013 07:46:37 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Richard Cochran <richardcochran@gmail.com>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
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
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130728214637.GC29970@voom.fritz.box>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1416484.XDfk5G56BI@flatron>
 <20130728131901.GA8864@netboy>
 <2529481.u8xHuXumcd@flatron>
 <CAKON4OzReTRb5JnJE+07vNJ-uDndLfqq8ha04J7K3x=WtsZEWw@mail.gmail.com>
 <20130728153546.GB5224@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <20130728153546.GB5224@netboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 28, 2013 at 05:35:46PM +0200, Richard Cochran wrote:
> On Sun, Jul 28, 2013 at 10:09:57AM -0400, jonsmirl@gmail.com wrote:
> >=20
> > 3.z kernel is free to alter the schema. But it will have to supply the
> > necessary quirks needed to keep those old dtb's functioning.
>=20
> The quirks idea sounds okay to me, if it can really provide forward
> compatibility. In practice, I doubt anyone will really spend the
> effort to make this work. I think it would be much easier to make sure
> the bindings are "future proof" in the first place.

I should clarify.  The idea of DT quirks is not to remove the need to
properly design and review bindings.  It's to limit the damage when
there are, inevitably, failings in that process.  And when, also
inevitably, firmware vendors ship DTs that don't follow the bindings
correctly, even when there is a good one available.

I think it's more likely that people will create, and get right, a
well localized bit of quirk code, than they will get backwards compat
code correct for every place in which a driver wants info from the
device tree.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlH1kT0ACgkQaILKxv3ab8ZJ1wCgiTBGSRHcmagJGaoAseiRWiAi
T50An0FNjwVq2aNaVE2D36wlc5t9j/vj
=D2pq
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
