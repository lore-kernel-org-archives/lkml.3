Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3FDMdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:33:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53600 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3FDMdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:33:43 -0400
Message-ID: <51ADDE7A.6090205@ti.com>
Date: Tue, 4 Jun 2013 08:32:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/3] arm: introduce config HAS_BANDGAP
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-2-git-send-email-eduardo.valentin@ti.com> <CAOMZO5CL=apxbkCHA6Xsw+m5d-rhe_VcOaA9KpkSmiJ=ZRL7gA@mail.gmail.com>
In-Reply-To: <CAOMZO5CL=apxbkCHA6Xsw+m5d-rhe_VcOaA9KpkSmiJ=ZRL7gA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2UKPRLSOVCDOFNSFTPXTT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2UKPRLSOVCDOFNSFTPXTT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Fabio,

On 31-05-2013 11:12, Fabio Estevam wrote:
> On Wed, May 15, 2013 at 11:58 AM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> Introduce HAS_BANDGAP config entry. This config is a
>> boolean value so that arch code can flag is they
>> feature a bandgap device.
>>
>> This config entry follows the same idea behind
>> ARCH_HAS_CPUFREQ.
>=20
> It would be nice if you explain what BANDGAP means here, since you
> introduce this option in this patch.
>=20
>=20

Yeah, I didnt do it because bandgap is a common term used in digital
circuits [1,2]. Also, as in this patch we do not add term different from
the common used bandgap term, I believe it is self explanatory.

I any case, I am resending with minor explanation.

[1] - http://en.wikipedia.org/wiki/Bandgap_voltage_reference
[2] - http://en.wikipedia.org/wiki/Silicon_bandgap_temperature_sensor

--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2UKPRLSOVCDOFNSFTPXTT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGt3noACgkQCXcVR3XQvP2ANwD/eP/deBrhTgpAmIworDP0bhj0
TZFZ2SS4hPovUf5fQBoBANBj2D06tTpnQZxABD6zhYpoozhzIM9/yD1LoVc0GzDU
=Hi6J
-----END PGP SIGNATURE-----

------enig2UKPRLSOVCDOFNSFTPXTT--
