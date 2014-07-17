Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbaGQXej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:34:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:38811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbaGQXei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:34:38 -0400
Date: Fri, 18 Jul 2014 01:34:33 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 1/4] power_supply: Add inlmt,iterm, min/max temp props
Message-ID: <20140717233433.GB21934@earth.universe>
References: <1404799461-26345-1-git-send-email-jenny.tc@intel.com>
 <1404799461-26345-2-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1404799461-26345-2-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jenny,

On Tue, Jul 08, 2014 at 11:34:18AM +0530, Jenny TC wrote:
> Add new power supply properties for input current, charge termination
> current, min and max temperature
>=20
> POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
> POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature
>=20
> POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT - input current limit programmed
> by charger. Indicates the input current for a charging source.
>=20
> POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT - Charge termination current used
> to detect the end of charge condition
>=20
> Signed-off-by: Jenny TC <jenny.tc@intel.com>

I've added this to my queue, which will go into battery.git's
for-next, once I have access to it:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-power-supply.git/com=
mit/?h=3Ddev&id=3D785bfcd0b23440a0c3d7eebf6ace45a56067b37f

You can skip this patch in further iterations of this patchset.

-- Sebastian

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTyF2JAAoJENju1/PIO/qaE9AP/2QsPrUH793+eLj+FSyD1S20
aA9lUHaHBztmcfNvsMwFkuXzldRSMoGgLEtaYIzItSQaoZKxiJKxJK2lBdF+9TWt
0HH2vq2Sw97AZiWfEkjuiEwST4KsoB6/3pfDLdbunm+2sqHOFGw63r8wQq4YnVzR
WbJ6NdtOxnK9/TygLuvHrtu2o3uSIoL+UowX7gT2N/0LdBdyB/xC/jKSM785cyhz
BcryqCaHjxdabJ8tKj0Xp65OeSgr17Egx1xPimCxecWOAJ4qtjDZruruS1bjynqi
M9c3Q1tNtKLbKTIweZDVvcY5vcjRXFztKOBrG7mCzfoFhHA946qTbh9OWZ2KdE8z
7iH0y6VcQ+HZjQsH51KyGUi9mIYyHNZUUEuaWfPHQqm6G5MabjhHHrWvaNGQhWih
EPQX6Cq2My3OVqe4HqPgpGyU7k442pxcIUubEdXn5kG6giaj/8ah5vlRoqkO5wiW
wdXln49Iui68T9WWsy/m8qZ9mVFmerq9SPM4lMMWLWcolTLbM57wbfJ5+25QKk+3
y+KGtFA8+KJrzad9Qx62ynVKQxp03b55JB4Jl7soDx+12CA5mTwjGDwB4xOfSIKS
zUxRZEOYI2wv2q1065zT4J1S2CCpxJot0MFD9utCtF7ELANJWjmRiP8oXN1gkdiu
iVDvERxNOs7cw0dnFG5Y
=5NGR
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
