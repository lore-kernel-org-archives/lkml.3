Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaH2LGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:06:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39353 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaH2LGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:06:32 -0400
Date: Fri, 29 Aug 2014 12:05:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, olof@lixom.net,
        Arnd Bergmann <arnd@arndb.de>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140829110554.GN29327@sirena.org.uk>
References: <1409254565-10677-1-git-send-email-dianders@chromium.org>
 <1409254565-10677-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PZYVFYZbFYjzBslI"
Content-Disposition: inline
In-Reply-To: <1409254565-10677-2-git-send-email-dianders@chromium.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: core: Add
 REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PZYVFYZbFYjzBslI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 12:36:04PM -0700, Doug Anderson wrote:
> From: Heiko St=FCbner <heiko@sntech.de>
>=20
> In some cases we need to know when a regulator is about to be changed.
> Add a way for clients to be notified.  Note that for set_voltage() we
> don't necessarily know what voltage we'll end up with, so we tell the
> client what the range will be so they can prepare.

Applied, thanks.  I've created a tag for this, feel free to pull it into
any other tree that wants to use the feature:

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/=
voltage-ev

for you to fetch changes up to 7179569aeb52197fd2a9909ba226c4c9cc0e2e2a:

  regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT) (2014=
-08-29 11:58:31 +0100)

----------------------------------------------------------------
regulator: Add voltage event notifications

Allow users to synchronize before as well as after a volatge change.

----------------------------------------------------------------
Heiko St=FCbner (1):
      regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)

 drivers/regulator/core.c           | 63 +++++++++++++++++++++++++++++++++-=
----
 include/linux/regulator/consumer.h | 20 ++++++++++++
 2 files changed, 76 insertions(+), 7 deletions(-)

--PZYVFYZbFYjzBslI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAF6OAAoJELSic+t+oim9QXEQAI/n08k1bg1hb6A1EWa5LYyP
xYTtsSCem4u7ClygZFY3dNsAtno5wrIfFIGDVGYBmjJVLDM4W0IzAEwP73l9w0I+
SyGOf/Y9pZGNf87bprgG5+U9iQG210bW56O/qr/lQ+o/XIo6fiNtdmnQY8xbsBDk
uZZvMdhnFAmTbVo/7tK7au3/llm5gvlsibJrQOmqcxtTRBvhRO2MUderWqoe+nsK
HJ1uL4vs/xVBNgYPiTkbMtTwrPQjIoMqvuGT1PoSZv/LqSqBq5qamV89WnhgWevl
kPD63NFWwwQ5lgh0rI+/aRqXc6X4IE7BsVzVv0SnKqxBLxNLGsf4PgzelO61x7l3
YOcymdjhJnV+7w3S9aNs8k9KlA+6iGsOYf/FmkF9Q3uLAIogbzu9IquxjKDzSxld
3H9LHk4Nr7vkxHo9uhkB69YeWnAh3HZqdklnYyAHN5eLu+u3z4JPclmc4u/rZrUD
fqNE2fPIegTDhn1RQ2n3PJl8JI5cXGhmXnpJ96+xrhkeFlbgSbdRIKquN/zSMyLt
kiIsNRht+1DO34+LKr2tYuXum70iF/SuTtrZFVlO5r7fIdoz0FbvWIH7kch4B8Pf
sq8olBZ7O9yT/UZyVNKYI2nhUn0952vziFu68PsZ/gmxrb1TIO6nHr98MPUR2K7b
gejCk4+VxIK9VFx2RBS9
=6Z8/
-----END PGP SIGNATURE-----

--PZYVFYZbFYjzBslI--
