Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935450Ab3BOO01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:26:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50948 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3BOO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:26:25 -0500
Date: Sat, 16 Feb 2013 01:26:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Borislav Petkov <bp@alien8.de>, rostedt@goodmis.org,
        Dave Airlie <airlied@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Including drm-intel tree to linux-next
Message-Id: <20130216012608.095525f7910901e2b479c2cf@canb.auug.org.au>
In-Reply-To: <CAKMK7uGnvZUkrkf1MtTKgQFOYiKQVk7r-hCVLgW+Htp0MuJXWA@mail.gmail.com>
References: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
	<20130214141953.GA5746@pd.tnic>
	<20130215102734.0ebe1b4826e94c83ed7a407d@canb.auug.org.au>
	<CAKMK7uGnvZUkrkf1MtTKgQFOYiKQVk7r-hCVLgW+Htp0MuJXWA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__16_Feb_2013_01_26_08_+1100_ApKtpJpeYv0Cs3Xf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Feb_2013_01_26_08_+1100_ApKtpJpeYv0Cs3Xf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Fri, 15 Feb 2013 10:43:52 +0100 Daniel Vetter <daniel.vetter@ffwll.ch> w=
rote:
>
> The patches in my next queue are fully reviewed and (should) have seen
> at least basic testing. The additional QA on top is just normal
> regression testing and about every 2 weeks a manual testing cycle for
> things like hotplug on the bazillion configurations we support (since
> that takes our QA team about 1 week to complete we can't do higher
> frequency there). The reason we've put that next queue buffer into
> place was that before the pulls to Dave received essentially 0 testing
> from our QA, resulting in lots more regressions slipping through.
> -next-queued is also what I run here on all my machines and what patch
> development is usually based on for drm/i915.
>=20
> Does that put your concerns at ease?

Some what, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__16_Feb_2013_01_26_08_+1100_ApKtpJpeYv0Cs3Xf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHkWAAAoJEECxmPOUX5FEKzYP/3ScVmJzsjjKVSb/wtunMGbs
ilcuSQSATxz+IocDWROy8qjFAYs765+I8RvAvy8Efha/9J/4d4OzCcKoNbE8Tiyr
F8nsVf5MQqYYJm0TErL+9ow/b5YC1SbpA68VQ5lL5cavZglPbuj5rGziZoXVPzWl
pUOZQiwAnnjD8KVJ5mpEQ9Bo3SAIFTkaefuRMlm2ZANsjMMnIYf7yIIXuZjfB+nN
KkTynMlpHG9N6X7MgMkA82vFa0gqv8z1hi/k4iDg641TUylXR3KrDmuKMCmalRq3
a78DQEVHpssU1fp6o9ehYUfY2WW5/Es0Af2awX0dmwuQhk5y2M3ZnbmeMvcxfM3F
bxi5dvFvih+FJaU/+TxNZH4t+lqWTJ7fYAoWaCZvIjXASZojsQwe8SY/b5j2iagE
128mxU1eG1ylY4r9LqJ8K3arKFKQ2v3N0ZVJxOrevBIdaU5hC9XU881sDdS0hZ4O
WXR+eoyiPHucsjOeex4ZE18XmiEn+3oNEE8YgE98PnHDmrytgVl6ov3TlOmzHKUc
UVKhE/3etbLXLIcvNFCQTuMCBQaGDsmgp0aBQJxEAQghZ6OB+asguxNHQF3mqrSL
R7WhKSeiZe/OElvkSFh0bAYMIN5010jTxYNAsnkBSAiB3i7pmLdypYQZGumk0jib
x7OA3zKICnqeaABKzMuW
=gKzK
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Feb_2013_01_26_08_+1100_ApKtpJpeYv0Cs3Xf--
