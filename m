Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaBZPnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:43:00 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40629 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaBZPm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:42:58 -0500
Date: Wed, 26 Feb 2014 09:41:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>, <jcbian@pixcir.com.cn>,
        <balbi@ti.com>, <dmurphy@ti.com>, <mugunthanvnm@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] Input: pixcir_i2c_ts: Get rid of
 pdata->attb_read_val()
Message-ID: <20140226154114.GJ30028@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393428486-15001-1-git-send-email-rogerq@ti.com>
 <1393428486-15001-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9pltayyoy9lWEMH"
Content-Disposition: inline
In-Reply-To: <1393428486-15001-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M9pltayyoy9lWEMH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2014 at 05:28:01PM +0200, Roger Quadros wrote:
> Get rid of the attb_read_val() platform hook. Instead,
> read the ATTB gpio directly from the driver.
>=20
> Fail if valid ATTB gpio is not provided by patform data.

s/patform/platform/

--=20
balbi

--M9pltayyoy9lWEMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDgsaAAoJEIaOsuA1yqRE4asP/2eriuoLHegpz0J8zF2vOdik
R4Tfd9AmgZUxtv6nIKBtzKr7Fr9XdolmVF2WIcwvI+k49yzGaJYwEoTqu3FcZZv3
auLb6xtdaxi1ppGbDTu1Jf/LZslG26gxVIkjj1M7Y04OAubvxH+uxpuLyhA/EUQy
aB3MvU1/Ue8HePmdUZ6uczGW/708nILE3DYU7LXJUPMt+G1A770I8UGlp3HGFKis
ba6HCutJh+B9NGeHNnyr9JdcyY6hwM8wgjAzJndBNwyQFb9gAOHUEqOe3CwHTeh3
bfjjkq4M0NmZESadCWL7DbNKJUUBqSSNXq9n17AS+7KkbT6R/t3BR9+siUb5GyYh
a75Y4w7TYIrbOKuGPx0oL0oSGPhci0rhf7AgmlyGhdtoY3KbmG/UhBR7YWV+0RYT
SMwfxStrK2JYL0p40ESQQX9Rmq5QZi1GSMUCCvJaf0lfEUTSv7p0pdqw9/VFMWvi
uKG7wzrumpcxdeinbH8qAQsN4gLuL5THXR/PxSuMvljqJ1L7WLQ1YWNMqLQXshry
vjZyWqTr8dyiaLQ6QB1znIfG6C+YOpIqQJtl0uMcoHoIP8C3Vy4lt/oyKgtuZhfk
SPiU6V8pkmy+ZZAxIt5m/nxdadbjPaDcqc1rQZ07X8/g3omS5EXQcyd2zlCpGirZ
/A2RVIRU5L9d3DgRv9Lv
=siyw
-----END PGP SIGNATURE-----

--M9pltayyoy9lWEMH--
