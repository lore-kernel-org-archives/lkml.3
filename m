Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaB0TDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:03:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51966 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaB0TC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:02:59 -0500
Date: Thu, 27 Feb 2014 13:01:02 -0600
From: Felipe Balbi <balbi@ti.com>
To: Loc Ho <lho@apm.com>
CC: <kishon@ti.com>, <tj@kernel.org>, <olof@lixom.net>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <ddutile@redhat.com>,
        <jcm@redhat.com>, <patches@apm.com>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY
 framework
Message-ID: <20140227190102.GB4862@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
 <1393524848-8207-2-git-send-email-lho@apm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <1393524848-8207-2-git-send-email-lho@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 27, 2014 at 11:14:05AM -0700, Loc Ho wrote:
> This patch adds function set_speed to the generic PHY framework operation
> structure. This function can be called to instruct the PHY underlying lay=
er
> at specified lane to configure for specified speed in hertz.

why ? looks like clk_set_rate() is your friend here. Can you be more
descriptive of the use case ? When will this be used ?

--=20
balbi

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD4tuAAoJEIaOsuA1yqREAfUQAJcil86TUuxjq1TzHSeVz1wu
Q+SzrpfZ/A2I1VsAyOMsAclX1heGZ5hIbDMIQkkC/YDqEHJLa8cfkw9wYADES/e+
cTWysat7CROiWOgS4P7lCOz1OFEteI8kKFMe+eStwPtTH4nTSZKK6vT79p+p0oms
fruJJr9Cir4TzxACcvjPNYMRl34p71GelYYSzOOFXydv4EOpnPKdwCZk08hIPM3l
9UwlfHhT+HNO5yOsiOMUqf80yy0s6LPvVhBbak0Jlk1Dw11BPmOdHHseyeRmbNfZ
C/N1d9XsBYcvDCCoX06pxYx0U152K9yTA9QWZ9EUrZEwFsGcJgrPg0SvpD9VpYMi
0E5Ecbb/nPqEWeyjvEjFxfieyO35NJWp8mD6SWnhk0nz4YiiWNQxi5tZcfPbdr0J
//xgQo3F19Ft2nWeRPo6AVhEJJdM9e8ysGrR6WTd3lOSQNS6kxhJUfwFtbKLvXQa
PuYQJR1GM4ryv4vCrzAx5hFrs4sA+/J6l/eISK/A8wTFDn91/v55fsPBc9cRCW0Y
v34bMfgMG6QNGMX6bJRAkUlB9UkYXp4N05TfJubZTodC3PEPFlU/VjCvYMVdijTi
qpsflCF/tyY9LtBBqIGVyWm82XY5/iFXOECHUqyH5nVWe47MKMm5uJA/9iy9SnNg
q65W1BiddizQNtonWPJD
=/V1M
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
