Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3FZOH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:07:58 -0400
Received: from sauhun.de ([89.238.76.85]:48213 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab3FZOH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:07:56 -0400
Date: Wed, 26 Jun 2013 16:07:14 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
Message-ID: <20130626140713.GB3119@katana>
References: <20130625163902.GA2973@katana>
 <1372236906-6933-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <1372236906-6933-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 10:55:06AM +0200, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
>=20
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Applied to for-next, thanks for keeping at it and providing lots of
useful information. Much appreciated!

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyvWRAAoJEBQN5MwUoCm20VIP/1HDPveLjqAXcQPvRqS2DtjH
O9qOFYk2nuEtwSiOxKzNCMdO/+fhMQZNAc+QDI6LRgRIszVKizqr6NiV4fGCm24X
GfByz5U6qZXJgu76evsuDMcu3VBZMnIBpriGn0jlSk0qGHGei7hsonGlkFnPzRr4
gXjvOXniro1oENRhIHyWB00A/ufehB4dB4n9vwE2OSy3vkAT1EJfbVOlkfxPv0Id
EpfcE7ll7C/xRGhOR4GvyjXa9IYoJgQG3iNyHOD6XfNfnYOzForyTV0uw07xzK7B
UXviMwxMkRFRpsmTlUIx/RvDPXRjrCW3xOl18SaJvErEoAgoa52ZgBqWFIfqHbAb
adkeaFP4q6x4/EWotrbagMIQzGUcFo0UHsyLJK/f3Oydb69rwVd7jJHld3Whd6mb
vhoNYcExvp7B37NZi5Z+PGsUf6NmuZE6B9b9n2+nr7uf3HXwMUajTOxx8S/ZxgLW
xmwgkWK0YK3Kau8VPrpfAVZELZ2V9gNS/gAuzwg3fyZfgR7COWLEQ/L+kxfDd8W3
vKTpL5MTYoRdj6DnwCVcFqON6olBlfaZdvLDABgtsv4Kq3l+5yDDmliNKl/u1DmB
8Nnm5zpZjJpN+hAcAkQylmzc7P6Kh0WjHUzrJoN7UpgbhsSc2OfdYrtFZsqN6fsf
SNDgeDYppcKKLKllNTRD
=XGk+
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
