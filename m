Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182AbaGPNNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:13:21 -0400
Received: from mail-wi0-f195.google.com ([209.85.212.195]:46754 "EHLO
	mail-wi0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaGPNNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:13:17 -0400
Date: Wed, 16 Jul 2014 15:13:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
Message-ID: <20140716131306.GB23384@ulmo>
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com>
 <1405510814-31928-1-git-send-email-mperttunen@nvidia.com>
 <53C666E5.6030009@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <53C666E5.6030009@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 01:49:57PM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 07/16/2014 01:40 PM, Mikko Perttunen wrote:
> > This patch adds device tree binding documentation for the SATA
> > controller found on NVIDIA Tegra SoCs.
> >=20
> > Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> > ---
> > v4: clarify mandatory clock order
>=20
> Thanks this and the new v4 of "ata: Add support for the Tegra124 SATA con=
troller"
> both look good to me. So these 2 + v3 for the rest of the series are:
>=20
> Acked-by: Hans de Goede <hdegoede@redhat.com>

Like I said in my reply to PATCH v3 7/8, I think this mandatory clock
order is a mistake.

Thierry

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxnphAAoJEN0jrNd/PrOhkncP/iyGERPZkrZbduzJZBzQbuL5
OXkmppcnCvf78ngO1k7x/I177OEgdJK/veHVXSJ9ZzJaRJfRPjvDEG502R4+MjG2
dgBVo30WB7XDU+tmqdY7uAABkPjaNyGQn9q8XHZdOue2jV14J3qjaAu0ZK3A1tf9
y7sda0EPQGYteWthklOY0/roQs6cHrvD7RYVK87/jgjb1mf46xEb3gKQ2iI4Flyq
vpxEUzSsP/u1hjUjY66C32UkKKGaDXoUGQSvDOlMkd1vELEdeR0G1gubam+W0IyQ
OTprXcJpq/RoqGgzoVj2rjFZw0g3kPurjPp4G3FvWCYeHKsDqEatDt4KiIFuQriJ
61cCQrmiEVIcqh+mdnerzwUlZKxlQPIOdbkOhSwm31Zq/300gdMnDkFsvwkv+QRq
5pV6Oj6KMUSllnnD5rUjKZ9fqGJAQyX+5EguJoGfD94PAbFywUHAALQz/Oj8s/if
/0mTROQ1cCD+px3IxL0FY64yEi0SV+NwJy7/3GnEGyb9ZKj1pHc/lO689FCXdcqq
XgKNRTPRcRipI7M+lON5dp/7r8l/2pBSE+KOGm5fk00lHO0vG0tD9lodTS6tHdwG
f/vCKGkNZ2yNtdwumulebTF1bIGM0Qfi+noBihyT12GAocdupA3/Bdkrs8XMq5ML
whzq/5vI/dqAa7o/pdoq
=zfux
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
