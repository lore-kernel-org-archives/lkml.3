Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab3HSANp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 20:13:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41587 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3HSANo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 20:13:44 -0400
Date: Mon, 19 Aug 2013 10:13:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: please fetch new git-based DM 'for-next' branch [was: Re: [git
 pull] device-mapper changes for 3.11]
Message-Id: <20130819101333.b26958e499a24fa8cd1fe487@canb.auug.org.au>
In-Reply-To: <20130816211810.GA8668@redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com>
	<20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
	<20130711135522.GN8530@agk-dp.fab.redhat.com>
	<20130712110303.06095e7b41c49c35bcd61fab@canb.auug.org.au>
	<20130816211810.GA8668@redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Aug_2013_10_13_33_+1000_HRu6oe/JLbRpWEAi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Aug_2013_10_13_33_+1000_HRu6oe/JLbRpWEAi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike, Alasdair,

On Fri, 16 Aug 2013 17:18:10 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
>
> To access all future DM changes for linux-next, please switch from
> Alasdair's quilt tree to using the 'for-next' branch of the DM git repo:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

Done.  You are both listed as contacts for problems with that tree.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Aug_2013_10_13_33_+1000_HRu6oe/JLbRpWEAi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSEWMwAAoJEECxmPOUX5FEyjgP/2LXSNWXP6I8EjMqzLKRY751
I5MtvCTJPOmNvvgevdocFeeJP/aS/UrhVkjIBZ3H0Aco57O/yhy5SKOLAecaNKhJ
odERZCHufsVAZ9kD7hPUyk1EbE8otrZJIbrikrBHDAnnBAaQAPlyDIV+W2pb6X61
WeMwtOLkQxbIZaKjdOoIWyzqNGZcFFpLdJS0FtzEkWEXcOIwZpt7njgYu/nZ1VNI
6TRWO2bNsegG4ntjn2RpFweiDAKj/TCiGFAR7WSDARY30qgjPqIu+PZodBmX/Y13
IQuq8g5CtRpei1i/DX+krbsgqcTZ5NUbXDVZQDTLC18ZiC78fp8bDGaNXEcolNIk
OnZfn0tz0QxsEYLyaECzmjF0YAR/rgMRMtryBhG9N78knKq/MkX/wknIIBdHT5tZ
lsM5I3yWu4KlwQE8KEp4IKSlFoygCgrAUooZ+7lGCufKsjDq9to0prkKGWnfhPNv
Ug9bEd1h+wfozq0x+n50bk4M1h2ikZqNoNKvwrbesUxF9Dfz3bXXbgAVBmZEt3wg
vpEaSAFsHWmdaRhfpPSMiqP1F+WpD7Q6EowyNliU4oXZRPeGhsenpAH7IXDSLYWy
C37IGTW5Z4gKKQuiLYU7TRiiiOEmvzrNQSkVOG8KdOFkL6KBGd5+lUjzg9ModHo5
UKdmIDAjeILLe02nD8rb
=ZNaX
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Aug_2013_10_13_33_+1000_HRu6oe/JLbRpWEAi--
