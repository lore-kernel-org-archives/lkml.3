Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaGQDPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:15:07 -0400
Received: from ozlabs.org ([103.22.144.67]:34278 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaGQDPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:15:05 -0400
Date: Thu, 17 Jul 2014 13:14:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jul 16
Message-ID: <20140717131457.15f3fb4d@canb.auug.org.au>
In-Reply-To: <CAPDOMVipLjtRCyZUYCEYLsaKWUaEwM1KbRSS9COUtdHj0rodWw@mail.gmail.com>
References: <20140716184550.18b6da3f@canb.auug.org.au>
	<CAPDOMViywcY=cYFT9EM3N3wESXQUX7uWa3jLLLKpv=QGF-Dtmw@mail.gmail.com>
	<20140717105144.2cb29989@canb.auug.org.au>
	<CAPDOMVh5_JXKwPQ9EwtXHLYnqNRhEMedF5F5K7H+PEqMuCZa8Q@mail.gmail.com>
	<20140717114718.3895d851@canb.auug.org.au>
	<CAPDOMVipLjtRCyZUYCEYLsaKWUaEwM1KbRSS9COUtdHj0rodWw@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/E0B3fP2AJT.sWZAxMwz1JOv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E0B3fP2AJT.sWZAxMwz1JOv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Wed, 16 Jul 2014 22:01:35 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>
> Absolutely , I am using the latest kernel rc from git. I am using gcc
> 4.8.3 and binutils 2.83.91.

Then that has nothing to do with me ... I am the linux-next
maintainer.  I just happen to use the same build test system as is also
used to test Linus' tree (kisskb).  I hope you are looking at the right
result pages for what you are testing.  The URL I gave you was for the
linux-next builds, not Linus' tree.

> In addition I am using  the default configurations as you are in less
> I am doing it differently.
> By the way xtensa-defconfig seems to fail because of binutils as I
> discussed this with
> the maintainers and they seemed to have tested it with a newer upstream b=
inutils
> then I am using and it succeeded it the linking failures I am seeing with=
 it.

Maybe we need per architecture minimum tools versions (instead of
current global one).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/E0B3fP2AJT.sWZAxMwz1JOv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxz+2AAoJEMDTa8Ir7ZwVNS4P/i9djsFFXaUyFrNyQXfXaV1a
HJwxFmw/U51uRtqkrJI/vdrAQVIBUcO/teQAkwkuB9rEbRs17CSHbWPxdAxEkPyt
wBmn8I2hw42YkT5vfY59n21VmC3Y0nrF1EHWgFxWeiFhdSQdya54gHHcKO729q8q
DCssQk8yQx8uzsrc1GS51A7BHKpOiQap07841dhYwaA/F+KFBtOeeQqf0Goi8q/v
beT2ZNHPoQOiccFc3SoH9ZqHij6v/x0G239Gf5MZMCRpDYPUbB5RLrseRF5GWWaz
rb6MMnB84Ag6IC3GgHjDXw+XqnXx8yRjcdE4+d9ufsboBlYi0YBA1R86yXuSfRG5
u9DPdPsnFmsKJE4D+U7XSlweiT+53exH/eyR/e343V0nlEvdvhV+t14DQTqJ+nFg
rr2DcKHaR85A+EVgBu6wlcZPtRuCXXk+xqWLulVy0t7bT7V+BBjKa1pGtismdVeM
V65rawaX0vAPh79eVmNqxBHEcHkmAbnrcEwc6y6qBV9NqkbEs52gOOHp665+P9ka
/ojPQMHIf+GE4ifFYs8vBiHSXZfo+HGKzfIW7T1MQUoqn+i6OBAIH4T1pLFeHO8I
wG49tTkWTxnZ1lvzQnKZsxFh6HhAZNsDQhwixCGm5RVyJ0/vcx2vK38YqJz5/WQK
7SZJ3aLPX/ufmiAGFqAz
=z5i1
-----END PGP SIGNATURE-----

--Sig_/E0B3fP2AJT.sWZAxMwz1JOv--
