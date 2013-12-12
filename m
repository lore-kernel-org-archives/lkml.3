Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3LLMgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:36:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38512 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3LLMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:36:03 -0500
Date: Thu, 12 Dec 2013 13:34:46 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 1/2] pwm: jz4740: Pass device to clk_get()
Message-ID: <20131212123445.GH11524@ulmo.nvidia.com>
References: <1386436396-2307-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZFKeWUZP29EKQNE"
Content-Disposition: inline
In-Reply-To: <1386436396-2307-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZFKeWUZP29EKQNE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 07, 2013 at 06:13:15PM +0100, Lars-Peter Clausen wrote:
> In preparation to switching the jz4740 clk driver to the common clk frame=
work
> make sure to pass the device to clk_get().
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/pwm/pwm-jz4740.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

Thierry

--LZFKeWUZP29EKQNE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqa1lAAoJEN0jrNd/PrOhn84P/3Te4cOI2N5HBFq7wRWQJhJA
2q1spkYpq72ChDYBE6xpjrELRUGBJtv8KH99S+3HEkKGwvWcmLdddUR2wDAnYmn7
a3hywVwNmo5QBkUb52eKFZ8453Fs652yxMUdw2I6P+/HQWvi5A1xcSB9lo6Y163v
3+J7P7ZD9dFwS0PXcH6D8wioCXfDYwOPw5+VgQxNIYBeBMkLU/vmsaT0bXKK+lNq
HXY0bBNe/ZcB1Jzo6LPzYvUV/RhYvfPPTGdcRwFMOyK5NMWZjoatxK+fcDI3ZD85
LgIYi+52l5Dx+C2/GVM/AAvYhXcdBlIF5BstY3W3ubDUjFv/6GIkNF2kCchl/9m1
uu+g60aL3A1tB+cDN5DLZbflt4HR3enZLN7MtO0qCxyKfZT2mL4w3kb1w6w6ptoD
9KSAike9AM4SiYCfti2bYw9iXPQXnQfTUr1+mzq5AIKc4/jLIYoVlVlsyGjyBMU5
QdtYDDQ5ib7p/nbEm7uBNc7PoTcVcUB8WfQ3VwxGcGWz+RAUehDGVuvQ7nBAEQ3O
q1hT4VkFr35xKOr3ebeQC9OB1VpQocAiHvlS1P1QPzLvPS15I+c2ZnQsif3sXdeQ
NbAgNuBx+rvqtiu1tvwoEorMXQG7XqtQeeWjuA+9gc0FrVcPR9oMt8eQ/1jJICwo
9wKyO/t2sgVlsq1tqs70
=mV3B
-----END PGP SIGNATURE-----

--LZFKeWUZP29EKQNE--
