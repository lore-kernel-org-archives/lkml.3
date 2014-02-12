Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaBLFW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:22:58 -0500
Received: from ozlabs.org ([203.10.76.45]:43951 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaBLFW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:22:57 -0500
Date: Wed, 12 Feb 2014 16:22:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        linux-next <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
Message-Id: <20140212162251.57472ed024ace170b49ec2fa@canb.auug.org.au>
In-Reply-To: <1386631570.32037.40.camel@pasglop>
References: <20131209191015.22974.31604.stgit@mars>
	<20131210101031.82b02468d32ddb89481b24b9@canb.auug.org.au>
	<1386631570.32037.40.camel@pasglop>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Feb_2014_16_22_51_+1100_rlRrq_CgXz3Z8bzS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Feb_2014_16_22_51_+1100_rlRrq_CgXz3Z8bzS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 10 Dec 2013 10:26:10 +1100 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> On Tue, 2013-12-10 at 10:10 +1100, Stephen Rothwell wrote:
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >=20
> > Works for me.  Thanks.  I will add this to linux-next today if Ben
> > doesn't add it to his tree.
>=20
> I will but probably not soon enough for your cut today

As noted elsewhere, this did not completely fix the problem and I have
been still getting this error from my allyesconfig builds for some time:

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org back=
wards

Could someone please fix this?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Feb_2014_16_22_51_+1100_rlRrq_CgXz3Z8bzS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+wUvAAoJEMDTa8Ir7ZwVWe4P/A1XEMQbgN4KUHbAsM5RH7wz
YIOmJ8NJdEZOLgP7WXgoPEJ2dy9ZU0K/wNBXANcuiZEpQ7MBRl0/r2VpCJIhOmdq
Dk7dJH/SUOZ8T8f/gMmE20vXuJkBbmt7+ycmKHSH7QHaCfxHnqzPfeFDXOeHWF9a
8WDr066+lu2K4N3TdennMHa38BQhzZTdD/XqZytuI3XwywUwDZeqc1lVj9oe0c7m
7Mtjx8xGnbY7HWnTfCBEdvD78L+83m6gvlvluC7S1Iiy3BarrKbUCTftdlT9AuIA
DLovvSLnieu3d11wnaxolExCLcWKr+kLDRfj/9CiKiOUVmR16k/oKF+ddpBZDuWM
ExFtzOSsDRxT9HRvDrSIUmFWKq+YJv2VBCZzG9pSY5LabwDmeJNbwSIJGbXwyZyA
HwEVKKQDE/eJuOSeejFbPz1JaO9CoInnc+6miXFrIIpYinEC8UtkxCQvzFpLyqz+
eXMNHRcKkW3yRp9BGeHTG4ojWPdj4IquthXrUOuhkMEKPjtiGxEVv7rjUya4zCqG
80mLm9xV/syRe4fHNJ8wPg56FkZNS5CeWLmNZq276eyVLPlUc6RHnpA0jnesePx/
SoEhTAXGRAoDvWLBtuEiqKlMa31ASW8TGc89Agof1jy5sYh1w6UFnDgz0nYOrIIO
grQY8QnnWmeQ0ppEC1Ym
=Yeot
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Feb_2014_16_22_51_+1100_rlRrq_CgXz3Z8bzS--
