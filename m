Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbaJVVdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:33:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:45517 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbaJVVdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:33:39 -0400
Date: Wed, 22 Oct 2014 23:33:34 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 25/47] power/reset: qnap-poweroff: Register with
 kernel poweroff handler
Message-ID: <20141022213334.GD28840@earth.universe>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-26-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <1413864783-3271-26-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 09:12:41PM -0700, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with default priority to reflect that the original
> code generates an error if another poweroff handler has already been
> registered when the driver is loaded.
>=20
> Drop remove function since it is no longer needed.
>=20
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Acked-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUSCKuAAoJENju1/PIO/qaYsoP/RApH0Y6xMMUdtyGykj4FkLB
EG3NIX3JEAAfbUu1IBxNEiwZaM3QT6uv1HGz9AkyvIYwZbPyJ9emiqSaHmSznZPo
Kag+O7hD049fis5WbJVhfitmiO0VfyrBDPY7WP0EFIK7gu1z+/IVmISADGpWPbiu
OBAgZFfF/AsCHxAScCMTuAyyQ3W5se6bBUKvK+8jlrI7gNC5kzyYajaqe7qNIhqz
/MA0rP28hVeUfHVuH0BhBlmgU2c6PuBbkCBylBv5P4pzXllJEY3wv/P040/+rjOU
wcqGcxsFOoapjLAPoaXM/ZIKY5ynmeZWhOMHMbmZtSn9q/jotGxooADS9cq0FV1c
DtpoxSdUGdWuSJwb8SptObSYu4cInIjrQI86bh8znwP+0M7uZiBbtELfmCKFPAOq
0kJv7leoA/uaFrEO8H6kkt7CXYSlpHDCVSauoKkzSHYEadkuyW99mX3c+YXuQncM
MUwV2flkgdsbdSjSgc46bxvW9zL/dh6T1COOHH4gYvao3fR2UCvOTdLlZ/M7lItK
vq7gcNMTQJnH3d+o6yYMOW7cpoyxMNyuyKYNwMkkzFTH2Oo28O5BECsnWGHO/LCK
RJN6g8ewAc3CmrzLzpNPHsVPpE7H4aQYRk8RbBEpnACPsgfH492xeO4Os0GpZ/RW
DFm6lddvbQESUuJd7W/v
=iCoc
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
