Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaKHVuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 16:50:46 -0500
Received: from sauhun.de ([89.238.76.85]:38497 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbaKHVup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:50:45 -0500
Date: Sat, 8 Nov 2014 22:51:55 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
Message-ID: <20141108215155.GA1266@katana>
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
 <1394779348-4084-1-git-send-email-mike.looijmans@topic.nl>
 <20140324161432.GA7524@katana>
 <20140521081727.GE2708@katana>
 <53808851.7060308@topic.nl>
 <20140601201134.GA3853@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20140601201134.GA3853@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 01, 2014 at 10:11:34PM +0200, Wolfram Sang wrote:
>=20
> > Feel free to adap my patch or comments and commit. Or wait a few weeks =
for
> > when I have a sponsor to split and update the patch.
>=20
> OK, I'll hope you can make it for 3.17. Thanks!

I now picked the part removing the interruptible-call. The part with
the new exit-path would need to be resend and retested in case anyone
is still caring.


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXpB7AAoJEBQN5MwUoCm2IQsP+wbjQdDLfWo7LpnbYIeHOb8r
gTZk9oL4WMvXBV2ETyioDm7bbL9dQhh997SL+VOiUrGwnkNFLsvlZsAXj3puvvrM
zasyq3fJl0XJ7P9FMoxJoqK3Q+IF/L2NoKev6O+C9E8OaUzp0rDB1Gq38zTvo9IU
jZTSuXhnn9W5bDIezxpVS1W/Qpg5tNqGMTMzMqKHzD4e8myFlqbKW2V5ajlxvjFa
CNc/dzzlG7sNydWUfO4y7BUxDhpz38Gb3vTyn8cTcohzj+wy/xZ/29so8sMQxMBt
P8ROTKdLhYTrA6Uf51JUrvzQKzQKC+tUvLBGXf3qdst75oeoUZr8HIFWYbZtkotV
9QFDZAQn1zNo/bfwEIkCSuhUtoeiFnsunegWAlfu6HKxZlCziQ6ime3cL0VAeKRd
0EVtAv4qiIc8uWvJspdbi0t0n2y8hplhNYWdzI4kMxkWGGzv8qxqbMK8asZb5GiD
5pgwGrLVfyMFekuJy+R68InH3ypsyAvXpo7mBQdUQDXTHxBHdNxFDd2EibII2xrR
Pdoha5JgBB20sA469lH/rcOhEY/2D19ItzziyV8T3YuUuiVXb5qn5dHuoPPIf+Yg
bhBEnpcsqYtC1YsSY1lKG4pJ5nQ0REqV+jS0481a/M1y6xGFFx/hZfEayqO2eDfH
ecQa27uCIBHvKl56CB2p
=j0QT
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
