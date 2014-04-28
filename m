Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaD1NV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:21:27 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:63632 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaD1NVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:21:25 -0400
Date: Mon, 28 Apr 2014 15:19:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] pwm_lpss: Add support for PCI devices
Message-ID: <20140428131953.GB15946@ulmo>
References: <1397819860-22213-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <1397819860-22213-1-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2014 at 07:17:40PM +0800, Chew Chiau Ee wrote:
> From: Alan Cox <alan@linux.intel.com>
>=20
> Not all systems enumerate the PWM devices via ACPI. They can also be expo=
sed
> via the PCI interface.
>=20
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
>  drivers/pwm/pwm-lpss.c |  161 ++++++++++++++++++++++++++++++++++++++----=
-----
>  1 files changed, 130 insertions(+), 31 deletions(-)

Applied, thanks.

Thierry

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXlV5AAoJEN0jrNd/PrOhY5cP/3hz7KX/CrdmJA/MLmJV52Nf
Wrcd2aF7oxbTVuVOfSnctopzu12iKY19wIfJGogiAUk/5vtZtdpWE/iMc6iKOyP3
o6IN6D+wD/vVGxvG8m7aSPhx9bOJG28JCu4HANsVNnE9EhDSqVWQasfHrM31ugP9
jlKR5z01QM5LzwLKo1MdUeef97H4zU9T1H+Uy8BPw/vyxeb18meGBjORUOZnty8D
5mh6WG94iP6Erj6ee48i6F8ZMEvVi/UPscMWXP0/ObnowQdoQX0qCidDpuoywjwc
/9iOOTsdY8L+K34fL1xl5QN7siqy4tOaqUSIBs1WdZDRyY/3FGG2YQkYoxgbt/W2
Sn3erMBqZwHHeMgcnWCvo0heysbwm3AFseoYMnvAVg4H/49yq79krQqqUc1oRlNo
8ZGwK9TKy8jN1WCXa/Tc6YBZNWp85UuIqhiHpdsyt92lGLwYFxjziN06ns6GhwvG
etdBKiVncMQjngMLWIrw2pRKXuWJCuso46EAvwgqLX3go/m7Gp1AQvGJ/2fQiLSM
cjVmvsOgy71FCF4bXFuKRrqNb1OvhqL+at4NjU63da0qrGaqblYnqkgSwh5IH02K
APdSYpTe00M+TaSEyvhGhee2UUMDt4TZKaD0MuKJFMilSW08COnYx9VYdvN9vhBZ
bDsj96hBNFFpLOJB+yCJ
=d74f
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
