Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaHKJOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:14:52 -0400
Received: from sauhun.de ([89.238.76.85]:42418 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaHKJOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:14:51 -0400
Date: Mon, 11 Aug 2014 11:14:37 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark D Rustad <mrustad@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: ti-st: st_kim.c:  Cleaning up missing
 null-terminate after strncpy call
Message-ID: <20140811091437.GA2730@katana>
References: <1407627938-24614-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <6ACE8FE9-A4AD-4A7A-890F-49F42B81C0A4@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <6ACE8FE9-A4AD-4A7A-890F-49F42B81C0A4@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > 	strncpy(kim_data->dev_name, buf, count);
> > +	kim_data->dev_name[count - 1] =3D '\n';
>=20
> Of course this does not add termination, but adds a newline at the end of=
 the buffer? Huh?

strlcpy?


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT6Il9AAoJEBQN5MwUoCm2aSsQAIoKSx+gXSkJjcS7yMwGyaci
fllrrG8ywGE+uSOUuUc5+8qshK75fq7avodvDTZxIAL21nswkJzJOVl/YdmafyFN
atuf7p/yEJE4PB+RyFvcAp+WEy/9MdU4R7SaXxNO/165OxWfB6fh7R1X/VR5S2C+
PQQseA8Gd7QwudBjIN7/ev79bfpGrIQx/0z8l2DFCWR4aK7aOi/FS+7vJLlNQkt8
2ZKIid1jStCrFWvq8+2kE/Giz8yFcVM+8zv8ya4kivVhW6RjpbcnqMtc82dCfvks
1xB7NKcr6FJG18fPEpsXTTIQ2PM8AtGXtTKhJdV57rI0wVg/PR9rklT3xxQXJ9Z7
25RuUI+qPkMTkYhX2ZOuLMzLKDcmOIWQ7PubSSliHQ9Lj4pRXD0QYSWX6iKtwsf9
5JCxfBvKpOnn8uLNDkhXvIsTDr8e9rOb6ytHfakuB8UCej1vWMMrbn96Wqqr491a
fZUxfvp3oswJTobGQ6S439WVneiiBH4TJc+4l5XaWde7U1gBzgHkWTquplAC9K2f
o0f40YI+BDTDroGexb1w7vkxBKBJAvmpCGy7Svhi7qG4Llte8uvzdQKxMuXkAW3Y
s+fT4vcrmAA7eRThjOJW9EF0NaodFezOyDIcdF+dnc1y2sc2cdyyFSg9bi1Qgydf
nkuJdtXV4DYzUelX0JCM
=lHmt
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
