Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649Ab3DBJlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:41:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089Ab3DBJlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:41:05 -0400
Date: Tue, 2 Apr 2013 11:40:59 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: twl: Return proper error if twl6030_pwm_enable()
 fails
Message-ID: <20130402094059.GD856@avionic-0098.mockup.avionic-design.de>
References: <1364742450.3834.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Content-Disposition: inline
In-Reply-To: <1364742450.3834.8.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3oC9nbwVaMqT63vp3GxgfpQH5v11UgnLMLpNe4tU+WQ
 dRxDQM597osAOePpldtL3FZpKm1QS6BTXCkzXLqZEKdHPIMBzr
 4wsVxI93n/qLTIUdOI2CaB8HZ+wc8/z6x9JmjIOcDMy6VK0ZBx
 0P5iHeByg4xvbED1d+N7griSPgJwXUHpVvgGMw/QfAVu0pZvRs
 KvAJXU4C5g5tBwc5fqJX6BVMZA8UfXLTknhb9jbQeymDz8lrc9
 nvdcsnkCLEvO3unNHFER7nIxKPeUewafBIM7GISuH6C292mvOn
 VzEu31Ep6E6BI/9x71A6/lMZSDu/LLbdzUL77gi6vAxYqewU/w
 RnJ1BEiweXIKM2+AmPTE93/ddntmkAYur2OwJC+OAYDQFwHLuW
 5KiYYbSvBK1j+opeU0uWj0+6QrVoh+HmI0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 31, 2013 at 11:07:30PM +0800, Axel Lin wrote:
> Return proper error instead of 0 if twl6030_pwm_enable() fails.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-twl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

Thierry

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWqerAAoJEN0jrNd/PrOh8WEP/i1tlGjTG+Nn9CiGqXSnDgTD
XKHasTxxSNCObRlC/0Kjmydd/5gYwEoHtjMKDqMd1kUqXWW3xhsblcGD+eJo9BdG
Z6RK+K3DSVPD/pJmpSArB1BrfNN/k7d/GDy97SBTySaKieDhez95w0Oh1dDyKR/K
7i8iArrgif0BCE8iCabTvTh2CHUz9KPXFtu9aWGfwoet8eqzlxwGRXc0c+aeZtNa
PR8Mrt3hT7QLnjSfCFMfyf9dzRMXCzCQoKRiolOsOIrPdwqzM/MP4EfTwsESkJgH
h371T/XTZ9UEcpYmqNk82DKcAMUXR+v+mX12KzxSpNFO09keH31zTKMaMaRros2E
QJoOY/Flv2VkkLMXzoCiCcHzRNxUt8ALZlZ5OIWKBJ6t6wdXk/u3j2cebLEQz8CT
AXPfpCI5EoPI0HxGUqIPFrcJOAlXqtcnIAjtGQq0QjlziIRB/IpGZx0+QuktiGEj
nf84AKCpA1OM28ehnuWL3I+IKXhQ0Onmz+sw/kxsbmM5Rdc50YO1iNhUkvucEqdg
xXo0lwUI/9owD6KrFJggbaVLpoUChgpSLrAUEKOqcvojb8kzNyEGmLibviw6KoUE
0ebQKeOg4UYhlSE3ADd5R6JLZl0dghPjohxAL5JVPpaa1iQckj8wIyEJFz6wNeN8
sEX3BtJQRlVSHt9mRpMd
=+Hdo
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
