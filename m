Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3CXVVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:21:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54566 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848Ab3CXVVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:21:51 -0400
Date: Sun, 24 Mar 2013 21:21:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130324212149.GC18316@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
 <201302171740.41985@pali>
 <20130217181756.GE1583@opensource.wolfsonmicro.com>
 <201303241550.42801@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Content-Disposition: inline
In-Reply-To: <201303241550.42801@pali>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 24, 2013 at 03:50:42PM +0100, Pali Roh=E1r wrote:

> There is no regulator 'Vdd' supply in board rx51 files. Can you=20
> look at code how it can be fixed?=20

You need to look at the schematics rather than the code here - the code
just needs to say what regulator supplies Vdd on the device.

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRT25lAAoJELSic+t+oim9xD8P/0Cyvr/yqKQPmdFJgDXEAwhD
PTwxVDpbtI1ajJURjiua+4VmdjxCwPDmE+AqNSUKrs6vvTvsz/q0KJSuus/yS4oo
tZC0rL+s91tnMdnxGcfRcNPwLCUmz4TWW2oRGe186SKHaWiS4/bCCGjKBywM2aDg
oB1TKVf51g/5XI6Vy0CeW5yj+ERGSHcimdsGFVgCAVdPGpJdF9F4Orf9Dr3L1gM5
k+ng2uC5Ng0E1uvI5COQGALFQusw3aPNoZbNIF0eGXx6/wLzuyNjgFzW4ykhTh6I
55vgM3wpettTeILLBeHU6lrb6cSZSkgRmhTKQxgimvtb1gcz1ncpuJvFl/3pC52S
Fmn4Y3aeLNzOQwwirAhDdVeD14KlmP2Wod63wMmb5iosVpqx9fxEhwtW5RyhphUX
oicZe8/jSMDLiAgq1FCfaXaXy940HuRKvyBkCVde8YsZDjERR3OnknpHG7cKM8DJ
utDQVcu8PQU7rIO4HAJy09hXXx7VbQL+UnA9LjH62Og7FOaN9opADinQSdwCRj0K
bQj9SWN+SODJr47m+TKTq9M1xZQ6KEuDcPzu596wFQHcWHIO2lmheYgVoSY7ZuxF
pzYrb5CAJiVBKnX6D33UtOS27AFpNsvoxHEbR3L6lLPMY+HGXZKcQ0HzsIAeHqkj
OlvQb1yAJ9/qc3GiSANt
=T44Y
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
