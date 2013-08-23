Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3HWIwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:52:11 -0400
Received: from sauhun.de ([89.238.76.85]:46688 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab3HWIwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:52:07 -0400
Date: Fri, 23 Aug 2013 10:52:03 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH V3] i2c: move of helpers into the core
Message-ID: <20130823085203.GC3035@katana>
References: <1377187217-31820-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <1377187217-31820-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2013 at 06:00:14PM +0200, Wolfram Sang wrote:
> I2C of helpers used to live in of_i2c.c but experience (from SPI) shows
> that it is much cleaner to have this in the core. This also removes a
> circular dependency between the helpers and the core, and so we can
> finally register child nodes in the core instead of doing this manually
> in each driver. So, fix the drivers and documentation, too.
>=20
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied to for-next!

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSFyKzAAoJEBQN5MwUoCm2bI0QAK5awQ507hl+3+q76tlv3bM/
+m1YNlqdEye7K3+XmB48MpCUi65bGtoITuOg+DaWYxw3+A7RhoJgwkFyMZ0gpesj
aHkFe51yVYiU4Zx1MVSpIDo5ufAmp+8FRM3TF++IgAq62/7fLtwhTJlU2qgzShzs
rw8UbmXg9+VjWFRfw1tAl+Vz3sWb9+vH2fmNiwXyPMglOdpClKe28rXrABJ78Gqc
cxqgatPqfBCxyob57z/hGShtPUZkRWdpMU/hjbfemsPrysbLQzmqVyVS2idFP1ad
T3mJ3xbKXcyJNO4NjGWazxPnpZ74RfNIJQ5nerZfqralO2gdVW8EFwCYaEy9k8YF
/EpBpMQkHz3Pb3eb4tZJa50cVCygjuikpPoxq9Mtao6T8VG0aVNj8NuE9ros2WS8
YWkRaVRDN8fjW98vuw7HmNuHCfFZV7QQ8uCcDtrl9k7X+fLQIvxPAVgrDs7Qmugm
9nzR9AchLDuHuBNRM42bz/t+cILX2ExwIMC5k1YouF0Inuvfrh3LSrEyaJSD8IEF
VeRGJPNSEP+Ww2+bGexV56ziz8JeMNLaj5rghDw9h9Jz5D4nMRjqhsRAbSfjrlMb
YfyMTzS/tmJgt2NPj2bc2DvK4JLfrS/SR5YsdWSgR6VQ0WUvPSLJL/rY8Gn/UJ2j
gfliuM4Sj6/OhS+bbMX3
=pGc6
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
