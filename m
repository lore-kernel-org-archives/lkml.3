Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3HSLYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:24:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54861 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170Ab3HSLYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:24:45 -0400
Date: Mon, 19 Aug 2013 13:23:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 5/9] pinctrl: sunxi: Fix inconsistent indentation
Message-ID: <20130819112308.GJ3173@lukather>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375610330-18185-6-git-send-email-maxime.ripard@free-electrons.com>
 <20130812082749.GM2911@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qD3brAgIG4LbUq6d"
Content-Disposition: inline
In-Reply-To: <20130812082749.GM2911@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qD3brAgIG4LbUq6d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 10:27:49AM +0200, Maxime Ripard wrote:
> Hi Linus,
>=20
> On Sun, Aug 04, 2013 at 11:58:46AM +0200, Maxime Ripard wrote:
> > Some pin functions in the array were not indented like the other
> > functions in this array. Fix this.
>=20
> Could you please take this trivial patch for 3.12?

Ping?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qD3brAgIG4LbUq6d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEgAcAAoJEBx+YmzsjxAgW7UQAIRgdNFhqwr7FC40gnY9wari
RlfVKh4YjwYvESt/U+kyxLthh0y2DlZ7d1h+Q/2hUJet8UQATfEr2+UXDRxbO2bB
qEY+WLXHwDYIpwrVKOVtEpz29tYMhEjpqBLpuWVYdn4Z5qVDdyFVCOgW0Cd90TFz
9yuay6kTtPeC4ajLh8k9JBtJXgE2x8lJAXSw6Y3c+SwX+xc5ff+3gSgfYy83h55v
HP0fnOAodCRetlTv+gbmXchWNvyhvhAbrVxnxfYBAuXj8q65jt2GCbg42KX3uyHP
VESMppRq4D/7M5GkLvV+BqBbhXHzwJ2vx7BBKCTjoMlURjMge3KIlmq5AS3xdopF
9qoW6QviDeqdZKHADRss7OpUsJOHcZBjEfkNpKG1WTFY37Pedlwv5kmmrLvT4r3R
wvi/GLcJl4GxD/05MV3NpJUSG9pwLvEYrqfz6QfP5Dv/7iY5y1NP85LgpZ/jz3ze
7XgRjT0iJbLWRVmdES+tb/fWRNMrc/Zg1dCm2wFeZkKKz3FdLxpW6R9PWyiEPMjZ
g3PNNJvscM4YlBlZr4jaOJWXNZhiPunuun+29PD3F/97fwHXD2040LepCwb5fBaM
jRhVUgDWuJ09qMkeOlNU3/TUi2WBRi9Kvdk38oK3cUAbhSy3omzMVS5Zk1B1YNvd
IFsE14BD5nSnKfElRWjB
=Q1Qq
-----END PGP SIGNATURE-----

--qD3brAgIG4LbUq6d--
