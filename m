Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaFWTAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:00:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50667 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753200AbaFWTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:00:07 -0400
Date: Mon, 23 Jun 2014 20:56:31 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ARM: sun8i: dt: Add Ippo-q8h v5 support
Message-ID: <20140623185631.GK19730@lukather>
References: <1403275973-24259-1-git-send-email-wens@csie.org>
 <1403275973-24259-5-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HUNbJr+8XKUS5qN7"
Content-Disposition: inline
In-Reply-To: <1403275973-24259-5-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HUNbJr+8XKUS5qN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2014 at 10:52:53PM +0800, Chen-Yu Tsai wrote:
> The Ippo-q8h is a tablet circuit board commonly found in cheap Android
> tablets with A23 SoCs. There are at least 2 versions of the board, with
> different peripherals, such as WiFi chips.
>=20
> Common features among these tablets include 512 MB DRAM, NAND, MMC, LCD,
> capacitive touchscreen, accelerometer, 1 or 2 camera sensors, USB OTG,
> microphone and speaker.
>=20
> v5 of these board designs has a ESP8089 WiFi chip (not supported)
> connected to mmc1. This patch adds very basic support.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Fixed the whitespace warning and applied.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HUNbJr+8XKUS5qN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqHhfAAoJEBx+YmzsjxAgnoMQAK7eZs8AhCllm6htRDHaviTG
7csqMo3CGnc0ttZvevXbYDe9RigZrFeZlpjc37OsUGZSFu/2QTqooCcIGV1QqqtR
LYdmRL7XxUK0IjFgYQMO+t9V7KZtYnzSOeG2Ylubx/b7eq0dhkIG/g7394LZdegB
9OFH61BzErXP4uIp4pYk861GK30kCedhTQA33073+7E3zjASgwnreThCpYYGKLV9
GeNhTAj+ifYWtClz+4UWh86kWfzKMY4YAYnHsbOCYQeYLS64gjvEQfJwrzmz6V4l
1C+XVpV9rN7DIkohCAFMuH7smqM+PdUzd51Z6IF3JuTaa0Kx7P3EomHvFzyy05A4
I99geTQsXC31/y4dOpQ7d8rWKcvCbGHtitAOEoeQxYYFyHoAFjSGab6hALQ5SpiZ
l9FQJCjf+9WK8vLagLuAPsi0Vv7K7A26PUz5X5f7/XeY/gvG4nk89WjLAaDfHPw9
U6KHI3VizKdzm67thpnlUI3U9l+eBrWajoYtMkmc9BFXKoNL3vYg0hk40kTaOJwO
+wflC6Vedvyd0ElyoHZFmW8y8I/SBjveNECjEgyAvgaMzf5gW9sOlHENBJGb5b+b
RYIr0IKUJIfCgwF/o+VwntwUl6XuU5xBgIQdxy2+Q5D19KndXS4MUQ2airCzrUPP
NMYbkzt5OqnXTA1vj8kp
=fkPf
-----END PGP SIGNATURE-----

--HUNbJr+8XKUS5qN7--
