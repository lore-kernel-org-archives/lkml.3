Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbbAMLAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:00:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60292 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbbAMLAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:00:52 -0500
Message-ID: <54B4FAD7.305@ti.com>
Date: Tue, 13 Jan 2015 13:00:39 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: fbdev: omap2: dss: rfbi.c:  Remove some unused
 functions
References: <1419181332-9322-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419181332-9322-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="cRad0NA9F68M9i05cAJSvgnjeS0j0FxFf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cRad0NA9F68M9i05cAJSvgnjeS0j0FxFf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 21/12/14 19:02, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> rfbi_init_display() rfbi_display_disable() rfbi_display_enable()
> rfbi_set_interface_timings() rfbi_set_data_lines() rfbi_set_pixel_size(=
)
> rfbi_set_size() rfbi_update() rfbi_configure() rfbi_enable_te()
> rfbi_setup_te() rfbi_write_pixels() rfbi_write_data() rfbi_read_data()
> rfbi_write_command() rfbi_bus_unlock() rfbi_bus_lock()
>=20
> This was partially found by using a static code analysis program called=
 cppcheck.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital=
=2Ese>
> ---
>  drivers/video/fbdev/omap2/dss/rfbi.c |  297 --------------------------=
--------
>  1 file changed, 297 deletions(-)

It's true those functions are not used anywhere, but RFBI is currently
marked as BROKEN so it cannot be compiled and the functions do not do
any harm. I'd rather keep them, as they give an insight how the rfbi
should work if and when someone will fix the driver.

 Tomi



--cRad0NA9F68M9i05cAJSvgnjeS0j0FxFf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtPrXAAoJEPo9qoy8lh71k/kP/0Q2zE/mX6PNjrgc69EMybQX
bBHal1CCTk6o5wyJVdStqJhTE6BjlER3Yj1pqFDeXuW8j3bq9wbY8pm4v1Heuk/6
lK/wbNsnFTCZMDx4kvnbdMn74/HqwLEcR6oK1SRXNN+zjPua1r0T/iJWPRIs7pKf
fdqMnd13DyFUOTejTneqSx9JAIpggAWVE7SXgkC0+vNa7XWln5F1HU0e10zp3M7g
hgQPOhw4QGxS+icgjgV3gRCVfH3hQw1ajQ4Tmp8cariU8kz+s7oKftUB4L+JgzU4
I3HjNYHv51Aj1YdX2yh19/SxDHkGax3Izgjc4WiDnilpz4HMcFHNHKEEpPw7c2Jh
X5v9YF5FWMaQz76QUW+hcsZMuREQVlysBtzYA0RnJCR5XBCKNIjvrOAhtv+sjcEk
p+cuYKokyL9l5Z0ljhXXyxm71/pK5JqYdMbtUXZ+/Hon4qy8qM37x5Eu+9FhmVvH
CGpxark838ldu5DQTij+7pHCbvorw5ijuOGpX0BfB7uLe/hPpEdgd92MK65ksaiI
KyvTeMyJu4aPlhge4XGpcxrZBzV6oJyHzWkRfkfKYWstxuf9/vo+ZV9Rk0cmHgy3
2ViwmMJMq6fZ5iL8AJeT72YKs6lY9zqNqqfwTPG4ijv4PV8WIlBatbadYLXn9k3P
XJ0wwBTKbfce8c06vWts
=KO+6
-----END PGP SIGNATURE-----

--cRad0NA9F68M9i05cAJSvgnjeS0j0FxFf--
