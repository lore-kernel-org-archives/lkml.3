Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaD0FOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 01:14:38 -0400
Received: from sauhun.de ([89.238.76.85]:47964 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaD0FOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 01:14:37 -0400
Date: Sun, 27 Apr 2014 07:14:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [Cocci] [PATCH 1/1] scripts/coccinelle: use BIT() macro if
 possible
Message-ID: <20140427051428.GA2671@katana>
References: <1398558586-28931-1-git-send-email-javier@dowhile0.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1398558586-28931-1-git-send-email-javier@dowhile0.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 27, 2014 at 02:29:46AM +0200, Javier Martinez Canillas wrote:
> Using the BIT() macro instead of manually shifting bits
> makes the code less error prone and also more readable.

Does it? It is a taste thing, yet I don't think it makes the code that
much more readable that it is worth changing the whole tree.


--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTXJI0AAoJEBQN5MwUoCm2TRIQAIne/oylYUk8FpDUJmR2tx7j
yk+k85m5nFkJxJd7K7CP205T3y/3oGwqlAwBWUQHtKMOToHbGkP+h3L/FEG0ubc5
A8jRGWJnD4MAhuS2y05K0ckdU9fwdlMYcgBg6IwdX2g0Qt+VqdZfpYaz/dgMAvo+
jph1HuioZ7sfZIqZ1SwzMnkZUXsrlwl4saeao0Bk4PKLmGscleuYyNNUsiEqyE3o
QRRjz0L6nsg3UGiH92A6PXsVrT8LfodVdoVQFFzM62W5964DKVOvSQKUNIZB45HI
wlHrtYB9ZYkHXlSww8O4yc2cMRqcZBhik09XJ1AVp5Gcq31Hjr6z1LCMn3k6F98a
odV/ACpy8Kx2GElJmwdlN61FeWb3Cx0BK65P8dqJC6nKAfWfYWIqlCHLTF5jZCYF
SKbbCsmQMwxiiDDd5/rfmB+EzdI3Bx3AooNtOxn1wmzEZN/PtTgWGdMUyoyTEBgv
zAd2uCn0RPgTEzXLadc+HItjAxpQkSY+5g2DoERAxHCZzSdFrekgLFb6IPYgsV7/
HY/VEVydg7rhHFFtMJ5RxXlKUQ5X5NMnf3pC2hYpMCBIO9UzH8u6jS96kLvQlkbH
9ECDD6W7LeJ0WMmMap0a2+le7dgMGJn3j7eyue3aZVH7CmboBDy6w2Tfo0u4zTwV
L/fX18a3KdK54Z0aiP2S
=1jfN
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
