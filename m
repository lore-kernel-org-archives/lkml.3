Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3IQIWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:22:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40809 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3IQIW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:22:26 -0400
Date: Tue, 17 Sep 2013 10:21:15 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/9] irqdomain: Introduce __irq_create_of_mapping()
Message-ID: <20130917082114.GA6757@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-4-git-send-email-treding@nvidia.com>
 <52377568.6010204@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <52377568.6010204@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2013 at 04:17:28PM -0500, Rob Herring wrote:
> On 09/16/2013 03:32 AM, Thierry Reding wrote:
> > This is a version of irq_create_of_mapping() that propagates the precise
> > error code instead of returning 0 for all errors. It will be used in
> > subsequent patches to allow further propagation of error codes.
> >=20
> > To avoid code duplication, implement irq_create_of_mapping() as a
> > wrapper around the new __irq_create_of_mapping().
>=20
> This function is a manageable number of callers that the callers should
> just be updated and avoid the wrapper.

Okay, I can do that. Can I take this as a sign that you're generally
okay with the idea behind the series?

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOBD6AAoJEN0jrNd/PrOhuOQP/37S/PM7W23HJoJ7QkQeRCJs
b8M0CB2JbOH3epRGHenbu0X6JgYshmZoNpcw5S4G4z7Qh7LH3kbCpL6GTXyRu1Jl
zpz2Bo4WcCjyVyT7JRYOtenzbejiuFvirOwsJb12cxDXrgF/1brj2CQXBKYLFHce
/X/5YHuTmubpTcXAvl5DShcKafQ9s26ldc9jLCEZsbxLpRtNHvE5QORRg/04FWk6
KzId+yDIM+ob0URvBaq/9OygxjfL7XZoFBK4HGDX8qwRd0ONN03Gd0RnIaLtCP45
dh3EGklJnlxOw+cvpENV/I+fwzbP71bk072xmq4M/DBnyVO7HZ6gGBr82Y3SbGZ4
b1iptU4ewmh3MkntLVzuYZvOiXH3seX+BWdiw5TGeASY17NkFJAphfBPrnjY+6vP
bDlD8APgdvQ0r3iU92CAC/xjJtF76BAQEVPz63DL1f46bZN+oCTzGlKjg5VEPjAK
7/cJJSlWR+oq2QH8w6mkzzsHbLsF6nEbPdXjZmi/QDw1qV/M6+dwND8LM/2iB9rr
J8BHX0/B7D6hah7l8wiaqSzpYjbgy5LfMuiKPgN7TYhkTvQ14En8Ml8Vxg8R3h0S
2convQV5s9OBoh+/MwAF4PT6mp/m5lr/BAFn1t+fgiwLspVrNGPlDwjYpGLZgwGh
8VqtwbJJDwKuK2pA9xiz
=5oTC
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
