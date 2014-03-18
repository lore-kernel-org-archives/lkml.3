Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaCRAiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:38:24 -0400
Received: from ring0.de ([5.45.105.125]:34178 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbaCRAiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:38:23 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 18 Mar 2014 01:38:18 +0100
From: sre@ring0.de
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] power_supply: Add DT helper function to get
 power-supply dev from dt
Message-ID: <20140318003818.GA17391@earth.universe>
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 17, 2014 at 09:43:43PM +0900, Chanwoo Choi wrote:
> This patchset add DT helper function to get power-supply device from devi=
cetree.
> - of_power_supply_get_dev(struct device *dev, enum power_supply_dev_type =
type,
> 			  int index)
> Power-supply class provides 'power_supply_get_by_name()' to users who wan=
t to
> find power-supply device with the name of power-supply device.
>=20
> If CONFIG_OF is enabled, device drivers which want to get power-supply de=
vice
> would directly get the power-supply device from devicetree by using of_po=
wer_
> supply_get_dev(). This function can be used instead of power_supply_get_b=
y_name().
>=20
> For example,
> [...]

include/linux/power_supply.h provides the following function already:

struct power_supply *
power_supply_get_by_phandle(struct device_node *np, const char *property);

-- Sebastian

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTJ5V6AAoJENju1/PIO/qau3MP/0ZXwc2MATHiqdHZ9Lo7GJ1F
7BDTBpFAbELKUglZYi2+n3q3kWNhci1NQhCkIkJUi0u+uqyZJk1ZMmnoA3b1udrM
dB5oGN2pSmH51GIV4YgkQq0iaLCHb0pPoq1GqIfGibYhBsrWU8cL+OdSO2hOyDph
hEdO8TCVz/5OV/2xei5s3MUL9BK/7GoehwTw4SUHy+/khVtU6O21houtLYLnVTYu
w9Pwxq20kcQn3LyfWycWx2aNg+VmAtbCCS6M+uC30IhVa1eQn0+Aa2pd+JA0KdPi
Ageb1odA8rG5gXWk6eL4RP2qrlT6hzaW0lujnfTC7XZ//wdpCaXeJxo6qB6Gy9X2
87Q7KrSSWj5h/4BX8fD7BTHsliesBAYZHNqd7IgrZGEP5MBL+p5AGXSrFaJrjRIg
BhtDL+s5YicY58OUORIk0vUqKpX5p44YYweFk7PfJ24zTeq5rTdcvgNRV8GT9l3m
KBrK+zg/IIIOhpaf/5Zmc6dWe1uC50mv6oZE+T2qzrwB4UEij56v1HNfg9JKLML4
22zvgNPZw2ZuMtuPxCNmBe3LUELeFRFSM8lo9qaFFizZr7oTj43umgAoIOk31VRZ
Fv0dand5hHr6VjcZUWJLHyPuhmtXMrQxvNf9o4C+n9tUGjpJYf/dDrcxDLBljrGi
tC2lqI87QHQltFWPFYfO
=wuKR
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
