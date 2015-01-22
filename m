Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbbAVOSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:18:30 -0500
Received: from sauhun.de ([89.238.76.85]:41414 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbbAVOS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:18:28 -0500
Date: Thu, 22 Jan 2015 15:18:24 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c: i2c-st: Rename clock reference to something
 that exists
Message-ID: <20150122141824.GB3413@katana>
References: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 03:02:03PM +0100, Lee Jones wrote:
> CLK_S_ICN_REG_0 hasn't existed for a while now.  This was renamed
> over a few commits, then finally removed in commit 5aa02b9 (ARM:
> STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock).
>=20
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to for-current, thanks!


--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwQawAAoJEBQN5MwUoCm2LRAP/1zdpPL5GWPtOz7mlPLlpHYl
yKJob9HwHrwSHKyHjVbBDr2SlzEzt6gWCvCp5aPhZ//6AW69XhHqzQ0OBFDbdHCh
ALlqWhP8YN3pfGUBDhlvSXT4+37REiuxbeXOd4HxKu+48Xiu/KN8RaMQxtGav9OE
XdmPv5sdsZj2PwnfAQ7SaTBAdmhzVjpW0zMHoMV69PM83uuIwTdlxRLIFL4iSuUe
/Kzrf+F/SAn2QHuHAhZhUQRbbTmpZO1OVoOofOt/YXO8LMFCWXZ7OInI5s613Pi+
E+U68AUjwF8OLqcW/+cptiNeiFJAvgl3bN53kcQ1SNagcCLzkvJMWG8Ngs0e0eMr
r9YX+EN0///2KuRdRRLeO9qQ7Kp25jtp6z++4z3t728M26eyWjdUXlwA490RlACD
XtKGCjRIEi70M6rIjatBPJ1YhMPXqdJtJWyAXcB5oVzSoxT6DZNeSUpRioO4P+pr
TAbmfUMfp35hcUP6kQn2j465yQkjLEY3YAl0Ji/8z4PseEqbwzcj9/C57BUx49sP
kgyH/tV88NwwxJHKpG3JvvR9ARP5rWGk8NoDhofCv2k896ssBNBF3CqZpOnWDTrf
LOzJi0+CtVDU8k/IZ2nQz7um55faSX6VxLON8dbqYYwRL1GXkRfJodzGa9gb6vlU
7bjeY5D5BkaZk+VtLnfK
=5Eg7
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
