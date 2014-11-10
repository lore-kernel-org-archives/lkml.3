Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaKJO5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:57:52 -0500
Received: from sauhun.de ([89.238.76.85]:54302 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaKJO5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:57:51 -0500
Date: Mon, 10 Nov 2014 15:58:52 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v6] i2c: rk3x: adjust the LOW divison based on
 characteristics of SCL
Message-ID: <20141110145852.GD10422@katana>
References: <1413168244-3553-1-git-send-email-addy.ke@rock-chips.com>
 <1413266961-3859-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Content-Disposition: inline
In-Reply-To: <1413266961-3859-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2014 at 02:09:21PM +0800, Addy Ke wrote:
> As show in I2C specification:
> - Standard-mode: the minimum HIGH period of the scl clock is 4.0us
>                  the minimum LOW period of the scl clock is 4.7us
> - Fast-mode: the minimum HIGH period of the scl clock is 0.6us
>              the minimum LOW period of the scl clock is 1.3us
>=20
> I have measured i2c SCL waveforms in fast-mode by oscilloscope
> on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
> It is so critical that we must adjust LOW division to increase
> the LOW period of the scl clock.
>=20
> Thanks Doug for the suggestion about division formulas.
>=20
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

Applied to for-next, thanks!


--d01dLTUuW90fS44H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYNKrAAoJEBQN5MwUoCm2JxgP/RQ0ca7fvIybu+DF9BRhWKct
ZqrnidDANnw/hRQiyIs7ueuNRGnZrRgSva2MzJzLpzWgfpzcALehXZvSE8XzAN1T
EBckkq+FUiAAVkYREsUIGYmVhYOjcjQIDW9seDXAdXncWtPvI1U+31dIH7phCy3O
Id3XgdqzoXbuzVzmBXSK95WXCeQUeuFXz/Iwj3mnhhA2iKRx3Szzj5XHll+l1oRv
N/aNWjLuXo8AMpfGiT1LfHcF5FMG5HdM8EqkMiowz22v5ClYBuAcg7ietYkuGqyC
DNHoZKniswntUuqcKNId2fz2xwj+XLGtPH0S2x7YDUH8Te5te0bR+vMzQAwvcWFL
KFnHhVQbuSj9/MJEZCGEyWcNxqDNRMgqqb8Un5AooYeN7ZH6RIgfKH5G+s50ON/d
JFCS9VSpePKAGgjHpxt4aEUHXx0ux1XDWRQwTGFTTR5xzoGeHXNOA2r+pjfaAj8b
F+deNxOpL5QNGj+sdtTnH4FtGWHGSYc2T05+YHYC4mZOjVpgdBUAtcquh14RrYrB
dq2Gvzjkrf+AnqXkde1JR6l8tvtKpBPwTSswk9c6nlLUGYN05U/GRjMuizZA8Xys
hfhJKADBII6hFRAqJY5EufocpI8LtCWPfgGQ+IqaaWNSFtYAvYhynGWFhi/YMG2q
NUMZuJ56Ut9NGbIq9Ekd
=5uV4
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
