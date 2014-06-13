Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaFMPNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:13:25 -0400
Received: from ozlabs.org ([103.22.144.67]:57463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbaFMPNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:13:24 -0400
Date: Sat, 14 Jun 2014 01:13:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: time to start cleaning up
Message-ID: <20140614011316.03c37c1b@canb.auug.org.au>
In-Reply-To: <CAErSpo5JdQ2xZ1bnvFt2chb2jTUzBHGig4imFj3C+Yn7Ux6nZg@mail.gmail.com>
References: <20140613120629.68527777@canb.auug.org.au>
	<CAErSpo5JdQ2xZ1bnvFt2chb2jTUzBHGig4imFj3C+Yn7Ux6nZg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gKNZ+.zRaX7Hx08lmEiCRAa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gKNZ+.zRaX7Hx08lmEiCRAa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Fri, 13 Jun 2014 08:56:26 -0600 Bjorn Helgaas <bhelgaas@google.com> wrot=
e:
>
> On Thu, Jun 12, 2014 at 8:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
\> >
> > See $subject.  Especially those of you who sent Linus something
> > different to what you have sent me :-(
>=20
> Sorry to be dense here, but do you have something in particular in
> mind?  As far as I know, everything I've sent to Linus is in
> linux-next, but if there's something else you'd like me to clean up,
> let me know what it is.

There is nothing for you (in particular) to do.  My comments were
mainly aimed at those who rebased (or otherwise rewrote) the commits in
their branch just before sending it to Linus, but then neglected to
update the branch in linux-next.  I see this as conflicts some of the
time ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/gKNZ+.zRaX7Hx08lmEiCRAa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTmxURAAoJEMDTa8Ir7ZwVCowQAJUNx5t1b/OwRayIQrcLheSa
Us9j3+8RM3XPDEVpmvTEoKsW4dxA34pFc9WXXBIgoNSyPl7bVyg3TD5H8BkER+QS
CfrxAaKVuv0qPls/QNDk/MgOgv/xY2KHNGiziRjtNwH7feqCIF5H2aEzYVdLoAhD
tL5qIilw/02CsJr/KISlc8pvN+AVAENhD1SlXrg+aLzsIDNPhLAWmGsM6aA+RttH
fgdeZdpTZczlHhXJA4d/9jwIs2Rg9DxeBbtfPQGv1NIED2/lixaCYsq4KLPaLVcH
GqUrNnZB/xSnprv36AIa18kN9cwGDWlHO6vIYaTm9HKGlHFmUHcwu/1b7DaVoPTI
ta1dq39JMx7XvW2IvUaXkuEPJ9UA5pfq3CwQoTs6e1BZwBNkWkR8yntq75hRPXkA
/8+MVSPdMS+B6EuAXzFx/TTLEvpV7CW5H72aI4hRtNa8yqNHk0WEJRBPNUOIY3E4
FeGJTa1Vck+zOIj2TK8pI9M2EqVv729MRR9IVeA8LjWwaWTuWdNUGy5/N5kK3+Qn
/XB8rsO5NZekuBTUJLD0FqKmGqWyMkdWdH03n8v2fX7IDvfydsLc610ObMDYcAXl
YW8TnMNvmKO39fAmiQSN+SGypf5gE5gaxSZBI5GET7bwfimUlDDV8HFan8+QY3Vx
lo63QMfnC0QxPG/iQPp+
=uLeR
-----END PGP SIGNATURE-----

--Sig_/gKNZ+.zRaX7Hx08lmEiCRAa--
