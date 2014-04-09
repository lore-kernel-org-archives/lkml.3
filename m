Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519AbaDIOuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:50:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33152 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932807AbaDIOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:50:07 -0400
Date: Wed, 9 Apr 2014 16:49:40 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/15] clk: sunxi: add A31 APB0 clk gate defintions
Message-ID: <20140409144940.GE28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397051478-4113-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
In-Reply-To: <1397051478-4113-6-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 03:51:08PM +0200, Boris BREZILLON wrote:
> Add APB0 gates support for the A31 SoC.
> This gates are controlled by the PRCM (Power/Reset/Clock Management) block
> and thus will act on a different iomem range.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRV4EAAoJEBx+YmzsjxAgOrgP/0Dkt1QLTn7ccNG0of2Pz/Wj
+TTRc+L10kuyQxWfv6QBxa6V806BCka2f/pwGVz3360DusFJcQwbyUeXJkMy5XRr
22vJ4/19VXwAqNxBLj8J0cCfHRmbBseqPtn91rC+JrzKGlXCrxmYryMKYHc8cyu3
/CzDt+TfrB7G/rwKjlPBegGM+kRO4bAwGo77B17TJV73WmB1xbrlSP4zjbnO3tb7
K8MJtXKEoQ8iW8gMAzEXc3MYSVr4Dq+3Ub8/YC1HwxDTRTF6JCwbqZFj/PPFl97s
dbuRPw66eJch9YHcD5FPRmdtpH4KfAQtF78y7YRjpLt+B+q0m0AOR1S/eyUgxT2U
Thhj50W5g1cF69X8xNB2/WBPpRf4s8YUA8Xse6a9mH7NNqHenXl+OuYZix2Rgl5f
BcYtkr2jcnGXJfx2TXjJhgBykTndNMAmo3llDlO9pRMVuNNsY/CIPVyf3XeWdmiG
9L13h9gdIVxb9fpqRZmVxc2Ps0LVMnZd8+PImqciIUV2AyXcCadt9IczL3pZTRw7
/5ea3hZisaHGtTLhZFN61aEwvjTLrRxh25+8hgfnuK5py8zpiudTJjrnCCqdzFO2
bYyDj6noOThqdFEEKWQNZb7fu32FXgTfCAgF26A6Od63WBZREGj27cf6pPGockSs
hc8CkESjuHBaGVJw8YrU
=8PvA
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
