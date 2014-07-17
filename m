Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaGQH6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:58:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:38691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaGQH6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:58:30 -0400
Date: Thu, 17 Jul 2014 09:58:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140717075820.GE19379@twins.programming.kicks-ass.net>
References: <53C77BB8.6030804@daenzer.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TbCLU7yw/pV5zSId"
Content-Disposition: inline
In-Reply-To: <53C77BB8.6030804@daenzer.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TbCLU7yw/pV5zSId
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 04:31:04PM +0900, Michel D=E4nzer wrote:
>=20
> I've been running into the panic captured in the attached picture (hope
> it's legible) randomly while running 3.16-rc4 and -rc5. I haven't
> noticed any pattern as to when it happens; at least once it happened
> while the box was basically sitting idle.
>=20
> dmesg, .config and /proc/cpuinfo attached as well; let me know if you
> need anything else.
>=20

Does lkml.kernel.org/r/20140716145546.GA6922@wolff.to cure things?

--TbCLU7yw/pV5zSId
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTx4IYAAoJEHZH4aRLwOS6tsUP+wZ4Tku4nBI2vDBIeYigu456
mNwyZKgcmfJ5PDo2u5lmc8jRpKVueUK8iWAEwvSAnNhMIpgNJZjO3ZABtr9bSlu6
TxfPDQoqRkG8tVyZW5Rz7ybsJ7j4jRYEHDmbTzQ7tw2Km7upEA5apb8xRKuibu3p
cIEmYAWgLnqL1+4qAFgjjPpbSYe0rRY+8JxuNnIXMnWdhitVYfSGJJ9a18Js2lf6
WTcsQxocTHRwJ30g8plDxile/nJPU3Itp23UAmxW80RUSKma7rhYdSvWJKw7WLEZ
4TJoR+/GPmAkQsxuMzF63P3kgVb+aJAZ7GofpRb/ordBsaBrB0O8ri7ZTnqyb2tN
hVmDVYUTDBkGjK4qz/O6maxSivzumv0wWa8pj/gOCb2ihFHN2XjKK+83XhulmGkO
36nyaHOgHAcUJlQsoYlT80HjO2VkT3DSRHP04vbxiQqvpXwmVpSwOq/kVgyCsSRK
WnUDeLrF0t2hMfH75dSWnpUpOx3TGZzhvfFAIiGQltTKUkLNWHMzErCpb5HPOJhf
n8ebQwtAq5sZ7p9oaSGG1SavE/bDGsiQHMmUC+tPySVHEeJloh7anygC/y+Faoft
XfB/Jwd0UICAL6B1VsygU9r3tV7lOHbpAZR/spP4Y/VxBYP1RmnaupUn9l0r2mMF
w5PV45pcUNPlhA8CAcKP
=fPGf
-----END PGP SIGNATURE-----

--TbCLU7yw/pV5zSId--
