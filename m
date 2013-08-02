Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3HBOY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:24:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56216 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601Ab3HBOY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:24:28 -0400
Message-ID: <1375453462.11783.25.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [53/84] ACPI / video: ignore BIOS initial backlight value for
 Fujitsu E753
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Date: Fri, 02 Aug 2013 16:24:22 +0200
In-Reply-To: <87ehac2oju.fsf@canonical.com>
References: <lsq.1375276989.822158812@decadent.org.uk>
	 <87ehac2oju.fsf@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6SPbtiVIfkCuOtay60X2"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.218.101.46
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6SPbtiVIfkCuOtay60X2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-08-02 at 14:46 +0100, Luis Henriques wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > 3.2.50-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Lan Tianyu <tianyu.lan@intel.com>
> >
> > commit 9657a565a476d517451c10b0bcc106e300785aff upstream.
>=20
> For some reason, this commit has been tagged for stable 3.7+ (and this
> is why I haven't queued for 3.5).  Is there any reason for this?

My import script assumes that versions are specified on the right of the
stable@ address, and anything on the left is an arbitrary name for the
address.  So I didn't see this version restriction.  I'll drop this.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-6SPbtiVIfkCuOtay60X2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfvBFue/yOyVhhEJAQoXqw//ZKbGOP9D6EhwWdMws2gA5EbWfPUgVTLF
RBs6Y7WE72p/19L+Ub9YiRjr88gDphC7KrK3Qpd/LJxLV8vhB2eCygHJ7qJSPHTo
ZCmMFr88f54T+CwthVIM2v77WUoWV49HTP4MmpIVjlqV7pOP0yME/nsgOhzfAP1T
0GWgA675Fgusnp7gOU/TxpEui1fcMnrcmJFNreSAqmUe7wrLt/SMcGXFBHm+IdsI
+F7tJwlqKTz2h32Ep57uwmFLIr6CREl1ztemsDxwk/pcGe36SZSGYoRKD79gmgZy
I5bI6WKOBcH0aHmT/qAJKGb+kBCvrW8C2xPB+ki1PUUI2AxR+JNu4yv95yXm2Qly
8zIj0l+5akW3K0dfoeGzVQyc1B8PuRWdjC7xlGuw+kREF1qLWy2/kgyCIAj2OE0B
mU3dMf5R1j9yh3ekf27W8EiB2TGntvqND5buakK1HJrc3QcsJyMRQESA1I3A4hKq
BzEuUs/9N1jBFzpgLajv9tyCvlKAuxLHYeGdK0Qno9q5zbUT6pl06K5acjqdaghi
fBsqFT4KoDobvSBV2QVjqvXZ1oCSsZKMVVu09L8SK5cfb2HKQfy9AC9zq58gwaJs
0nvqJQzwSZX6Tcb5gq8VTjhh9hd+ePneAOJFUUO2OVf50TIpD+iZW2/XbNfxrRPb
N4Iik7XgVdk=
=YrNR
-----END PGP SIGNATURE-----

--=-6SPbtiVIfkCuOtay60X2--
