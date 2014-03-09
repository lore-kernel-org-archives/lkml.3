Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaCIJDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 05:03:45 -0400
Received: from sauhun.de ([89.238.76.85]:43455 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaCIJDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 05:03:43 -0400
Date: Sun, 9 Mar 2014 10:03:39 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and SDA
 hold time value
Message-ID: <20140309090339.GB4695@katana>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
 <1394201571-11681-3-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1394201571-11681-3-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 10:12:51PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> On Intel BayTrail, there was case whereby the resulting fast mode
> bus speed becomes slower (~20% slower compared to expected speed)
> if using the HCNT/LCNT calculated in the core layer. Thus, this
> patch is added to allow pci glue layer to pass in optimal
> HCNT/LCNT/SDA hold time values to core layer since the core
> layer supports cofigurable HCNT/LCNT/SDA hold time values now.
>=20
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Can you make use of those instead?

        u32                     sda_falling_time;
        u32                     scl_falling_time;

This is more consistent with using sda_hold_time and lets them have a
common (and more readable) unit.


--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHC5rAAoJEBQN5MwUoCm2KaIP/1S/CKW9OKuq80kcEmTgzaGn
LD8fUdOxEfkdbL75g0MRSiEwaLUWKL4tjIpp+SUvru8K9zZTrTiej3Ji+rETil/Q
Qmwyzghr0TormD+yCrySrdx4LHp5BfG2OSSPugmMGDHAH8a9miXm6CX3IUNnGH17
Uwpqhibb5aYQZ388y51EToTuntV1zHfCuHmSjebOJSLazHXmk6KFBnyayLlZKNQK
aw0sAbkcPPb5WVsP6fIRYGk3sddJgxxqKbjLF1Q79mlKe2PIFDva9/NBWP/feXk7
vWtsasBx3sauOY3BVZHTOucwhdyq/A+pKb/htQb6Wwq9xyD8mbcU0DngCGMHof9n
nrynXXAmjpYaiDvakWFDZJm0d38NehIIDsyk7zITLEz4AA08Ui0M+O7BYVDhYM3K
5Q+JOlVomaTuE+HgiJuOC14B7V04+Py4/9LiquF/roXYL7MSM596kpIgwuqoC97x
gT7VA+x9kufKuvA6KYczZstt0oikGM4B1LjNrwCrn8+ZvGVdO5ImVfMCQZyzMZzU
wnic65YEtMp/XQVC+sRkeoMbMiJFV40iGYxlaMdIuG9EDeESzvJF8VNa/te93BOl
KVKR+85FNrSVzZhKx7NtizqWROeR+DK6PO41C+0xKm2juCGqCedKmeoWg5tz3Kh+
eFY/BC7HCsoIeE3z+bPr
=Dct6
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
