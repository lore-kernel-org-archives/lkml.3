Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaIPXAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:00:38 -0400
Received: from ozlabs.org ([103.22.144.67]:45913 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbaIPXAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:00:36 -0400
Date: Wed, 17 Sep 2014 09:00:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Foley <pefoley2@pefoley.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the rd-docs tree
Message-ID: <20140917090020.1f3c2c30@canb.auug.org.au>
In-Reply-To: <CAOFdcFMDnR50cS-Geb0S1S2VRPzZqDr9zzqUp-DpMYLfF0qtvQ@mail.gmail.com>
References: <20140916171102.61509be5@canb.auug.org.au>
	<CAOFdcFMDnR50cS-Geb0S1S2VRPzZqDr9zzqUp-DpMYLfF0qtvQ@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/f=yz.PyeO7utT1hbO05K.KE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/f=yz.PyeO7utT1hbO05K.KE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Tue, 16 Sep 2014 13:19:07 -0400 Peter Foley <pefoley2@pefoley.com> wrote:
>
> On Tue, Sep 16, 2014 at 3:11 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > After merging the rd-docs tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > Documentation/vDSO/vdso_test.c:15:22: fatal error: sys/auxv.h: No such =
file or directory
> >
>=20
> What glibc version are you running?
> It appears the function getauxval (and I assume the missing header)
> were only added in glibc 2.16.

My build machine runs Debian stable which only has libc6 version 2.13.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/f=yz.PyeO7utT1hbO05K.KE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUGMESAAoJEMDTa8Ir7ZwVWysP/R1FORLGxa068qJ7Jp6RTrCa
gvhUcOZ0cJ09O0YFT11x/sOd7Q9NHFspf7tHln+/zw6y253UUiVFbo4sdKJlb/AU
suPZo5CnDaVAhiZ/1Glv3XcAaYsTOyqxjkzMVUqpRRrJYbMw+l91c2BlrVOSM2eK
VOyr8/ILOMEo+bcpN5ARz0tm6l6mhHcxgAEgI9nVthACTqGovjEo4C7tSJvpPNRv
tvB9UsAFVy67BC98fGUbCBfZM3wLOC0b8icb8P1QlziI1+pb//RqDEKouiZY7UdP
H+tm/zzfAGoBPj19u8T1tpbSmVVKC7rkAKoSwJAGYc5IAzbCw7HLaWZGErt7TQ8+
8ub+nLqwr342HTIFRozJteNo5LohQZLOV6L95jLElc1Z3RlBHaOJIku0B9rPHFi/
LtFBZ/gpJhCEq/pb8xquZEI5yxOVPPmmucXgau8fKfAvsuOjzfv5JEQD7kGsV79u
lBK8cKAvqRfIkTrTM6NhO3CTJv5YD/A3qyNXvBgWW0w9smo+USF69nVMvNHoI3Bc
quWfEzdlJwRCwpYUhwMDkOhF8kXKkEKOqaveCBiFYQVTzCiahosrF8bxLubgo4mD
lM2u+2uE8GcONC2AlWEXvXXny+xrNXmTWwyJvs5USeseHE/ujYY4QIr1DWYLf4w+
gbiibr9t/Ft2OcCkMHPs
=8Sek
-----END PGP SIGNATURE-----

--Sig_/f=yz.PyeO7utT1hbO05K.KE--
