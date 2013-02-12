Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab3BLWa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:30:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40212 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3BLWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:30:26 -0500
Date: Wed, 13 Feb 2013 09:30:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: linux-next: manual merge of the acpi tree with the pm tree
Message-Id: <20130213093014.b6d0a21e1299823763ba3113@canb.auug.org.au>
In-Reply-To: <51197FEE.9070606@kernel.org>
References: <20130211125856.64b216a03dd18218c4627635@canb.auug.org.au>
	<51197FEE.9070606@kernel.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Feb_2013_09_30_14_+1100_aqI+iN_U5V6UZwfP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Feb_2013_09_30_14_+1100_aqI+iN_U5V6UZwfP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Mon, 11 Feb 2013 18:34:06 -0500 Len Brown <lenb@kernel.org> wrote:
>
> BTW. Rafael's "pm" tree now carries the ACPI patch stream,
> so it is probably a mis-representation to call my tree the "acpi" tree.
> My tree is primarily focused on the "idle" part of pm these days.

OK, I have renamed your tree to "idle".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__13_Feb_2013_09_30_14_+1100_aqI+iN_U5V6UZwfP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGsJ2AAoJEECxmPOUX5FE3J4P/RJ980Qg07leJjdupnYX2W4K
QxD84nlM3zkFPQB36Jm0C23ApnpLqo9mWIuk6rGaRrA3+Zn5LQRa2KTlTsGyydNa
Fv49QWhJwMt/2K1JeZ9XK3ty05kfXASJaDNFULb7TSIAw0gPXOZNUTkCmt0fDoCt
lMRo+aCRb4lTC0vrkt0hxmyX+v9sdyIWLiw5y38MPZDQW4lwY32zt5jgByUZhpdr
goiZtAEQHFixLgV+xsxkazt80GwUYHWmiopJoCwgvi5CvyhNJQLvkLQcC4jU1GxJ
cNQaVUZm4Htn2UUOkPiu3Fw4iOjVkp0ABWwTOHto1sO0QU89KvLdHY8TAELMysY2
SMa5awtd5hH1AyDvvhzAHiMOjQvOBnVGqxtfOW/6QDZxljtwxhMal3rr5nmU/rYA
kWbaFJzilFRMAcWcU7KffCLvXwZhLqu9QJgVk5U0vrPbGFMsyol0H+sKkbjmnRM+
70pKATAQcOL4l61GXB54Wm3dEr7bspjoRbclIBcai+XO/pmgQPzGAvgnT8w6PSWr
tHzK0sONlQN5A+H2jTLGQg86jOmntK2u/sgIdt+gT8wReUAUS6mFLbz54eA8yybN
zOwUfEqPRH66fo68Qqte47LqyiRidrElRYzyH7Q8010DdbNf/TOa34rFblrSWFRd
l9xz0MvaPrfgmXsD1K4U
=uqZT
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Feb_2013_09_30_14_+1100_aqI+iN_U5V6UZwfP--
