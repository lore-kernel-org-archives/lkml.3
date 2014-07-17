Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbaGQPFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:05:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55434 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbaGQPFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:05:42 -0400
Date: Thu, 17 Jul 2014 10:05:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with Linus' tree
Message-ID: <20140717150514.GG10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140717165238.2e056cba@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cyV/sMl4KAhiehtf"
Content-Disposition: inline
In-Reply-To: <20140717165238.2e056cba@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cyV/sMl4KAhiehtf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 04:52:38PM +1000, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> include/uapi/linux/usb/functionfs.h between commit 091221417853 ("usb:
> gadget: f_fs: resurect usb_functionfs_descs_head structure") from
> Linus' tree and commit f0175ab51993 ("usb: gadget: f_fs: OS descriptors
> support") from the usb-gadget tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks that is the correct fix :-)

--=20
balbi

--cyV/sMl4KAhiehtf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx+YqAAoJEIaOsuA1yqREtW0P/RAEUff6sYFgRqhTxIJQOxPn
tt+xpv+bhs/nZ3C/blB+bvIaMECnNDfIbvv8PSKaTI3u2LqSW7KAuAXHcO+WrRMp
KVv424pFF50sVlHniYwVKYIu8IqpqvzU/D25B9tkTwfn7GNxlz7/nixRTOVEfFpC
TvjCogzCqXlbwvie6qd4ujD1vfKvbKtZl5tzkiO3IdJSPWDiBavaTRD1AyRexn5C
tZwuIn9/NZ3Mdf5mlU61mS8OwBcpg/ULpb+WKSPMGlI29Fwk7+my4r7J7rHMpW53
u2SCRpTGKMkURjQqls4EVAXkJriXOLgJ8nEdnap2iVvmKTgcE7T9Fjw0G4Aw0zmV
09Kr8Z6lB7Q7jCoS1nP/3PwT3oPZd2ieUJwkseYfnez3iNgWORFuBt9oUWjYo3rY
QHXLamPmMg4Zy2bGKQCgDLQvn+VNYp0IazW9qJ+x8nBfcTeOZ3zi3ZyrF6XqsL/7
UerwkVToxhg9M/C3XqJPt9z9PsW/RyQZkjCCxRtc1Gts7IYaW+KT3mwlYunVixjP
4JuwLWjScXJWuN2b1IAlYiiJittDeJOGFuBlmVb8Wwq0faxXxbmdKKDA6/92hikv
h8mjABnpZedXPghCS0nLolAH+Di+DHiHJQm2iiyQKpDvdVZ6tm8XvezSdj1sMd9/
bjKRJBfcvHSqjATEIUem
=yPBl
-----END PGP SIGNATURE-----

--cyV/sMl4KAhiehtf--
