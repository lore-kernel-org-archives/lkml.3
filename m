Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3HFRMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:12:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38848 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3HFRMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:12:46 -0400
Date: Tue, 6 Aug 2013 18:11:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130806171156.GN6427@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-3-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lBqJz4CGKwlWe7/k"
Content-Disposition: inline
In-Reply-To: <1375180329-4860-3-git-send-email-richard.genoud@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 2/8] ASoC: atmel: machine driver for at91sam9x5-wm8731
 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lBqJz4CGKwlWe7/k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2013 at 12:32:03PM +0200, Richard Genoud wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Description of the Asoc machine driver for an at91sam9x5 based board
> with a wm8731 audio DAC. Wm8731 is clocked by a crystal and used as a
> master on the SSC/I2S interface. Its connections are a headphone jack
> and an Line input jack.

Applied, thanks.  We should really be able to merge this with the
sam9g20ek driver that's here already but we can do that later.

--lBqJz4CGKwlWe7/k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSAS5ZAAoJELSic+t+oim9wsoP/iymoohS2yx71cDisVCXBgS7
JOFFy5h4Teps6KexuM191oDdahBeJf+OpI0JeIwiPsph+F/2TXhzLL6yibR9mu6K
wutal63C29RyBCkf0NObc7xl3IqHY4aaNBv1IForUmvE4se9eoDEvWxy2FythqEx
aG8MET96AZgLb9Y70aoe5q3aR0SJEBa2HcR8MI7EA/qdIivFnVCdYjwhwpMXzQdz
1u6tV3I7cIWFjpbKN0WRAoFFqc1xzT9gqQ5phYVCmiFbt2b+4jyC7Ptj/hSzarlx
vUOn+SRTc9cW0YiuZWqgmafAFcdIcMMTLq4FfW0WWT+jxILDd5CfDEDwjEmoEy+V
6dR46QL2jyZRTpzZQcPmvQqE/RTzhZfEmokf5OPFsgAI618SSHUw7D2iUIZ3Bo8m
QACAPm7L9loyTceCbCVNT36M6kWtVI2iIbxdqmncYMtrEb8K7+iccO+O+f9fIj//
Xr2BcI1vewX5ovr1r4aLEFF8cSUOkL8hw1WxlP3Ym8G7aPFTDi59ITzXuWMcE2/R
muh8XEzj+x/0aWC5gpsec+YjSUgXTxSNz4pEdSk8BW10VRn1Z/5xxc3L2XtiGijx
P5IgN4uvdDMbUgX/F2pLi36HjoiFBxHJk+7c3nKgSySiFUTQuD23M8Q6ztAJ06Hi
YkKeXv59wf3YpanhWQI4
=WTVc
-----END PGP SIGNATURE-----

--lBqJz4CGKwlWe7/k--
