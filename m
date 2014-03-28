Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaC1Wot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:44:49 -0400
Received: from sauhun.de ([89.238.76.85]:44620 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaC1Wop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:44:45 -0400
Date: Fri, 28 Mar 2014 23:44:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v5 1/2] i2c: qup: Add device tree bindings information
Message-ID: <20140328224435.GA29200@katana>
References: <1394762863-12154-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1394762863-12154-2-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <1394762863-12154-2-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 07:07:42PM -0700, Bjorn Andersson wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> The Qualcomm Universal Peripherial (QUP) wraps I2C mini-core and
> provide input and output FIFO's for it. I2C controller can operate
> as master with supported bus speeds of 100Kbps and 400Kbps.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> [bjorn: reformulated part of binding description
>         added version to compatible
>         cleaned up example]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---

=2E..

> + i2c@f9924000 {
> + 	compatible =3D "qcom,i2c-qup-v2.2.1";
> + 	reg =3D <0xf9924000 0x1000>;
> + 	interrupts =3D <0 96 0>;
> +
> + 	clocks =3D <&gcc GCC_BLSP1_QUP2_I2C_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK=
>;
> + 	clock-names =3D "core", "iface";
> +
> + 	clock-frequency =3D <355000>;
> +
> + 	#address-cells =3D <1>;
> + 	#size-cells =3D <0>;
> +
> + 	dummy@60 {
> + 		compatible =3D "dummy";
> + 		reg =3D <0x60>;
> + 	};
> + };

Removed the dummy child node (confusing example) and Applied to
for-next, thanks!


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTNftTAAoJEBQN5MwUoCm2PuoQAKVx6sddGPno3KxkkSDMXNQL
JVVQVXxGTpTMlyOYPTNyBzBS+qkJ+2KezoJoee0wpNHLdqchuQvu/Q2Ti+IafwlY
TGRCmxD4g+cHRTQdCCWOou6bFOCSsOereKh17eqDPS4ETwrnnVeoB+Hf8gNqhFuD
PAzcb7L3db6h5/30hEeRC1wlf2ahyMJz/PXzWCQ9FPOFG0Pubd0c4aiPlpP7ZOfi
4p/TboNdIkTdSJN+9W2aqvyqPUsJMtzV9zqV8SDRYzLkIhmIyhYtY7lYlcaxlNiY
pPTNs9vubmIgofsY4IYBIqb/Lqc/TlvHflaB2G0L/JI27qpmYd2Jj5H5N+DXB52F
ZfAH1xYFuhHQmiStFdd7Y818i7gngW1yo10FcRU5UMjZnAhzepeckKLMqWsZUP+G
qTNfVG0/FSRGkO0hyOQrDMFU/0gneItJVWWSHkIrtTCh+sYhzFnwCRtf4SGOLvOB
qm4Ay9phCEaAcpgmjT8u10VurI+aYwYtuiJ7dUK8d/KMgjTpzblBiPNP6zgKgrzf
1/8vrx3b2d3XW8zvnBgMkHywOumVLHcdA1DQhQma3TSZ8bsSPdLKxh1tUtsLKkEb
xuRMs02RQ4CPqE8sGYnFel1ewZvLSYH1Z1PaX7J4a7p5u3RzzZL6ut4n/JuoEr9a
y299qVSEkuZZwBdNK04w
=IK9+
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
