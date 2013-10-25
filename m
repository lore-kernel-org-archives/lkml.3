Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3JYWTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:19:06 -0400
Received: from ring0.de ([91.143.88.219]:53177 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab3JYWTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:19:03 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 26 Oct 2013 00:18:52 +0200
From: Sebastian Reichel <sre@debian.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131025221850.GA8657@earth.universe>
Mail-Followup-To: Kumar Gala <galak@codeaurora.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Florian Vaussard <florian.vaussard@epfl.ch>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
References: <1382626126-12565-1-git-send-email-sre@debian.org>
 <1382626126-12565-2-git-send-email-sre@debian.org>
 <FC6F0077-7E61-4F64-94E5-10E8FEF1F1E4@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <FC6F0077-7E61-4F64-94E5-10E8FEF1F1E4@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2013 at 04:41:20PM -0500, Kumar Gala wrote:
> On Oct 24, 2013, at 9:48 AM, Sebastian Reichel wrote:
> > +- interrupt: should be one of the following
> > +   - <8>: For controllers compatible with twl4030
>=20
> Just checking, but the interrupt is always 8 for this device?

Yes. It's currently hardcoded in drivers/mfd/twl-core.c.

-- Sebastian

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSau5KAAoJENju1/PIO/qaIokP/1RaF9TR1vfiQdBkVzhjTMNM
O0mHgNHPfuUUHsViwmGwx9AJ6aspLhSvTVr7KByhm/JgbSRuLfOV2wrFR3ptH1e9
MTaENaI8yfSxQTVtxTQFyd9QEFPP4iGlBonKHjY+Mgo8gGPBErqOMg12tL40RgYz
nOQ4WBg+sP4/jEyusz7uNvGK3wurM2evLL5TJV+GviWgt/gL8VYZq8UPOFJu0YpD
Z+fAnKK0hAtbsVoTjmNbF0GRkt2oo5w25H0iZ1RWKVtDfYXZdzuQRqZObmt68pTQ
P6bJnQOctkahXv3Kp2g7b/Is8fS/04zat5xz1+aXqMjuXdJT3Cuzgoano0mFHxMo
saNEwZSRIgSDTF4wARJn8X95L3TciTvHwAuqF1iS/PYzgCmt14pGNnbsRhZa7Agb
RAmwNiWnkKtccMEzcoSNuvQx3NNKdu9NvVW62P6A3lSyI4tfFlwV5CZkNA6FvqNt
HENpnoESX+j2zVx3kpM+MwrpKDxsPKNSqXeJZRnGv7zAL3X7TEY5zOO8sfixbPxB
b5conGRQ6s0B6VAg9RMJCdtzIUT74TK8ebSwLLJqggaAoLcJJlV+DM9FwJjgvEFP
6x/LhbfTu0R9RnHlpfkEwKCGPNTyCNSzRIGCkKgYRSWQ+retpuoa7DTuWHWT36s2
PT0O0Kxazgb/8blQBY2j
=sRTo
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
