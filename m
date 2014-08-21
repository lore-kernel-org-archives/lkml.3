Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaHUOez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:34:55 -0400
Received: from ozlabs.org ([103.22.144.67]:53088 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaHUOey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:34:54 -0400
Date: Fri, 22 Aug 2014 00:34:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 20
Message-ID: <20140822003440.3ffc15c4@canb.auug.org.au>
In-Reply-To: <5248cecd-03f6-407b-a4a7-1d2989ee0469@email.android.com>
References: <20140820061703.6128f99c@canb.auug.org.au>
	<20140820155222.GA24407@sirena.org.uk>
	<5248cecd-03f6-407b-a4a7-1d2989ee0469@email.android.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//DV0sjgtgZ_yO/WorxD6JRr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//DV0sjgtgZ_yO/WorxD6JRr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, 20 Aug 2014 13:53:56 -0500 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On August 20, 2014 10:52:22 AM CDT, Mark Brown <broonie@kernel.org> wrote:
> >On Wed, Aug 20, 2014 at 06:17:03AM +1000, Stephen Rothwell wrote:
> >
> >> The sound-asoc tree still had its build failure for which I reverted
> >> a commit.
> >
> >Are you sure about this?  There's a bunch of updates to the tree
> >including one that's supposed to have fixed the build failure on
> >PowerPC
> >which haven't made it into the tree, was there a problem with the fetch
> >perhaps?  I just checked and cgit says I pushed 23 hours ago so it
> >doesn't look like a problem with the push.
>=20
> I thought I checked, but I may have missed it, sorry.  I will check again=
 before the next linux-next.

The fix appears to be there today, but I dont; think it was for the
previous linux-next.  Does it matter that I am currently in Chicago
(despite what the date on this email says :-))?  I guess I must have
fetched your tree earlier than you may have expected.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_//DV0sjgtgZ_yO/WorxD6JRr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT9gOJAAoJEMDTa8Ir7ZwV754P/2JWu0tPnDrgzm15djkNcjqt
ruRk9ZCz//8sJ/s+uUYDePLnZapnQnwcOW5LktmdYd01gW2iokDoG7yo9m+HYQ9d
sLYNc0Hlkf8fcc0pi8k9KcNLun001EE+EXuMAE4/Eu6kE6mt7Q5JOFSwCR4j4orb
pitTm74K+hqWePZkMeAaGT3D8FowwZcXvHE+HCtyZF5wYLATvWPSym9KvpdpeAZa
pwVojVGdT9uUXA3PapWbjEMHl0t2ioP/SXT34ywyiAWHhgJUNZ7cnuwQg0lB3W70
iGlM2Or+pKcv9eK1TJXTbLwBZMroe5/eJLK8Q2ypfCYhzYVN2RWpkz5a1XNaYY+t
T9fKo3yKy79tnB2CWGqEkcNWpeN0+hqbDTl0Uud5n+bIanhy6zy2v4c4FVb+LA8Y
DBoQdTQI4ig+8aLXQI7tDlQk3fyjSk+AH9ovEugbTxEgPUTvBEBv30US912ixqFK
x7nyXlsmmZyBquYNCFeqogpjdjg8kPSMrMqGdrBqR+nM5kv4LX3Ao0Dp2DTSmbud
UWK4z/AM3fABqsMGuqeUecYPB1mUt01c37pNRS6HkqvxYFMN1905XIkyGJ4NQHTO
DJLcSqoSHQdzqpet2Xk4SQCe9Q8YrFneEfrmnqgKGd+4bcRAE+SWaMndBPIAjn2q
yuF443FFWBXLa8Hp5qnA
=/N6o
-----END PGP SIGNATURE-----

--Sig_//DV0sjgtgZ_yO/WorxD6JRr--
