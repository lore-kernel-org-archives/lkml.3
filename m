Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaKKHnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:43:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39306 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaKKHnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:43:14 -0500
Message-ID: <5461BDC6.7090308@ti.com>
Date: Tue, 11 Nov 2014 09:41:58 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <plagnioj@jcrosoft.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH 3/4] arm: dts: omap3-gta04: Add handling for tv output
References: <1415051968-4878-1-git-send-email-marek@goldelico.com> <1415051968-4878-4-git-send-email-marek@goldelico.com> <20141110233050.GC31454@atomide.com>
In-Reply-To: <20141110233050.GC31454@atomide.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="MhvWsGdt5gJCHT59upjoHSVeBoW8QX8io"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MhvWsGdt5gJCHT59upjoHSVeBoW8QX8io
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Tony,

On 11/11/14 01:30, Tony Lindgren wrote:
> * Marek Belisko <marek@goldelico.com> [141103 14:01]:
>> Add handling for gta04 tv out chain:
>> venc -> opa362 -> svideo
>>
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  arch/arm/boot/dts/omap3-gta04.dtsi | 48 +++++++++++++++++++++++++++++=
+++++++++
>>  1 file changed, 48 insertions(+)
>=20
> Applying this patch into omap-for-v3.19/dt thanks.

There are changes needed for this series, so don't apply yet.

I'll try to find the time to do a review and send comments soon.

 Tomi



--MhvWsGdt5gJCHT59upjoHSVeBoW8QX8io
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYb3MAAoJEPo9qoy8lh71hhgQAKBEHdxqwh+ytM9xX9R8w3B0
a3yeVeiHiyTmfhKys9F/vGdC4R3mEhZpWDpPh/z5N589141ocnY0nKtAbC9w/E5W
o/0ssEx2fX8/y/q3m4T7KoYCzw6Iq45GE+W3HVzK4pcwtwRKGFvI8jzr/9G5ymae
LCgErOnAbj8dNhi4H8lpt9ueZ8O0KNpBLNI8aN4L/cJMrzg0GwTOerk1N/ZKFV+/
LznF9acxVsQMuCUZlDTUhfrZ8+o2GOb7CzjcC0qGb7VzipQZu2vWWBtkZeV1w+lj
uyFjDRTjLu4rPPWjPFLrJ8ZQUWsZWegt5zPwmY5jGla3/6rIBn6FEL/Ee25Gvsin
I1bXDgdxxo3D6dt338w34nbgUhwDjZkP46EVQPRDk+1w3tC8C5N7Q1LXsZPuczf2
zZs5OIFJnpc1Ssf7ANWz4NhaYgglFow9iMHPrXqbZyKaE/hMJz14ao5BuySoqegc
lKBEezmzGtu78uEnr+bvgKEvhEV6q5poMhHq2NAn78RwQ81W+13rfb8NYsCspJ2b
ntWrO7Am+0684ZVIyT+gzyMxcXUmQYOCs0iA1Kwlno026c4omFk+QEs9lpXPmQe8
PsRxaeEyFuHshqg0feWeXEQ35ze5dKIW8lpdS38ihT6/BugLtoQFwZYrwEIzzImc
EnkRN2xTmvIiGwIl6rX3
=B8gU
-----END PGP SIGNATURE-----

--MhvWsGdt5gJCHT59upjoHSVeBoW8QX8io--
