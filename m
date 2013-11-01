Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3KANIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:08:43 -0400
Received: from sauhun.de ([89.238.76.85]:59226 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab3KANIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:08:41 -0400
Date: Fri, 1 Nov 2013 14:08:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH 2/4] i2c: i2c-bcm-kona: Add support for high-speed
 mode
Message-ID: <20131101130835.GC6734@katana>
References: <1381960909-1735-1-git-send-email-tim.kryger@linaro.org>
 <1381960909-1735-3-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <1381960909-1735-3-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 03:01:47PM -0700, Tim Kryger wrote:
> Add support for I2C high-speed mode (3.4 MHz).
>=20
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>

Mostly good as well:

> +enum hs_bus_speed_index {
> +	BCM_SPD_3P4MHZ =3D 0,
> +};

I just realized that you should update both patches to add the supported
bus speeds to the binding documentation.

Thanks,

   Wolfram


--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSc6fTAAoJEBQN5MwUoCm2C+oP/01f0n7jc8cQcCU9zKRno0JT
WeAuU3Oh/y56dMjRO0DFJaYgBKBmshWopxa4iIBfQtKfNeIuneqiVIMGSlQA/qyo
vYuYElpAFMSZMOtJ9dEelNpyR43qyqZoOlRLouv6JmwGhoMEs2lUjBD3AfKwbDCH
CfTFv+2KrRQMmoag6kBC55nCP47y4uKfa6B+cjIvkh++XYJShD8ZkTtZ+SXObZZ+
GMW/nrGEtazAtyWNhwhrpMeULj9PcOmQxzsLlRU8pONhCz/KENy12aHYEuKOxQud
UnhZcyyaMHnb6qhsQNTjmRsEDPHwca3fyVjY2KWQzjR56SxtzJz5fWnkX6Uhsr6g
c3DVwiAOBFo8bP8bZywMXD+aqJe2Jv9dMXjGgJt+B5eoew166EcS1Ffcs3q49Ck9
LuytP80VlhMye1hjPlFD/tBbCiOufikdZSXpFRdllQuH8SThPZiRFF4s7B1csDtP
B6yx9ZjQSQF5U6NckCX8DMPgwB5NuOLjDhqHnEUcjajCRsH2LBGjq+PiTQH+2V2e
KNcEgbzuwMrnBId9wk6g/nL3w8jpZGfiQdXHIh8XAosRhkOpyOL5rixhvvfOX+sG
7WffNTUWSrlMhn0JYLAZH4J7vEBu8VxJ5bFAjrQiNqgpfFifVZXYysCPyLUfscpR
c1dftctVWsKEJMgT3vrW
=j+lt
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
