Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaIHA4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 20:56:00 -0400
Received: from ozlabs.org ([103.22.144.67]:49149 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaIHAz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 20:55:58 -0400
Date: Mon, 8 Sep 2014 10:55:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <jdelvare@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: jdelvare-hwmon tree unfetchable
Message-ID: <20140908105544.61149a89@canb.auug.org.au>
In-Reply-To: <20140902095455.77a91b40@endymion.delvare>
References: <20140901132808.c7b08f4ffa7055dc28e6dac7@kernel.org>
	<54049590.6060500@roeck-us.net>
	<20140902095455.77a91b40@endymion.delvare>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g2sZ8m4kGqelYAJANX4gO6M"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g2sZ8m4kGqelYAJANX4gO6M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Tue, 2 Sep 2014 09:54:55 +0200 Jean Delvare <jdelvare@suse.de> wrote:
>
> On Mon, 01 Sep 2014 08:49:36 -0700, Guenter Roeck wrote:
> > On 09/01/2014 05:28 AM, Mark Brown wrote:
> > > Today's linux-next merge of the jdelvare-hwmon tree got a conflict wi=
th Linus'
> > > tree which appeared to be due to the hwmon quilt series I got from St=
ephen being
> > > based on v3.14-rc3 and subsequent changes from mainline interacting b=
adly with
> > > it. In addition I'm not able to check the original series since linux=
-fr.org does
> > > not resolve for me.
> >=20
> > Jean dropped the linux-fr.org domain, and his old e-mail address probab=
ly
> > won't work anymore.
>=20
> I can confirm that. linux-fr.org is history, from now on I'll be using
> my @suse.de address for all open source related work. I thought I had
> already updated all references and let everyone involved know about the
> change, but apparently I failed to do so, sorry about that.
>=20
> > The alternate (and temporary) pointer he gave me
> > is http://jdelvare.nerim.net/devel/linux-3/jdelvare-hwmon/. It is empty,
> > so you did not miss anything.
>=20
> That's right. As many temporary things, I'm afraid it's there to
> last ;-)

OK, I have switched to using this as well and updated your contact
address.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/g2sZ8m4kGqelYAJANX4gO6M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDP6VAAoJEMDTa8Ir7ZwVU6IP/2zQMlKn/1YVgZin0BU87DgO
Xqsbo2XVxOag0w6aSjYGYIU8b0U30O3Z6sXKsvMWx+4f0sVgiN22j/IfdrKMo0rZ
m67F2spFWuGBgH6jqtVOyUpHVr3mkiOzOX6YfrfAND4ZYXU65sySXh4pQg7CFgqa
GDhjtX1OG35olEegz8p7N39LJGmbqDIqPUkT7XPZPcTpBRTvx1gyfOIV5LUDWRh9
/ULOswEbPOk9TfvPVZN26CQzyfkpe7qcZMNHj/4Gqs2dSNassVEeMZUYjZrSoeVW
K0bJuymbSP0Aj2WBy5SSRwRM9QzZHMjHrCq1KfvzUfHjOcm0aPKeL8oaw+grChQ5
z1hCPiOaEZ9CnblSMZ+ldg/Fh48TMwY0hX6JJ7nvyWTl7xf5WjE42Yf5ZzIuNeJj
APwrFTxKd/GPTJg/9FU4341XrqKuf+n5hUOHqkkTnueehCjTDETGJLXoPHAJFdWJ
5fNF2vWS7OBhoxRFzjQ/q2aR+Vnlta3sr65DGLQfVRm9Zh0L6y4fBe8NacJQEbCT
5j00r6uDj1htvYCL0DwaeZ1l0YK9m5ni5umtojlGrMW+ok7XKQA6FSKQsPSrjq/g
o+XfP4uqvEM8WJtze0lG824MxoTZ6YGwWxeejYipsIGHZpIPyH/lvYvNUXD6pMmk
+0qLenA+2nxwHWp9XmkB
=vmce
-----END PGP SIGNATURE-----

--Sig_/g2sZ8m4kGqelYAJANX4gO6M--
