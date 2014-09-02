Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaIBLjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:39:21 -0400
Received: from sauhun.de ([89.238.76.85]:54071 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIBLjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:39:19 -0400
Date: Tue, 2 Sep 2014 13:01:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, dmitry.torokhov@gmail.com,
        sergei.shtylyov@cogentembedded.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v4] i2c: rk3x: fix bug that cause transfer fails in
 master receive mode
Message-ID: <20140902110159.GF1266@katana>
References: <1408669991-9703-1-git-send-email-addy.ke@rock-chips.com>
 <1408730452-3552-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Content-Disposition: inline
In-Reply-To: <1408730452-3552-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 23, 2014 at 02:00:52AM +0800, Addy Ke wrote:
> In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
> in one chunk, so the size of data to be write/read to/from TXDATAx/RXDATAx
> must be less than or equal 32 bytes at a time.
>=20
> Tested on rk3288-pinky board, elan receive 158 bytes data.
>=20
> Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> Acked-by: Max Schwarz <max.schwarz@online.de>

Applied to for-current, thanks! Please don't send new versions of a
patch as reply-to of a previous version.


--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBaOnAAoJEBQN5MwUoCm2dMIQAIJTTUnFg+LST4rb9omcbLxI
gO+HC27P8x2AznVbqPHv8fEOeok2Sjvff58QKpjbQtc3c+86EBCnNAMgRa/QQ5/0
ZLRuGDYaCqFMqAXwMz3giDYJmeZrwVGKM3ME4Fm5UfnTg+aMKdSUB2V1V5WTYMPE
5vWVizuWGohhn5rq8OPHUt2c4WFJLn+cDzxwrzl3F/QaOARs7YkELPsYmr8xMpJi
I+1+y0y+hRcdcM7pnlys+wcQIpgTty6RR/E+2eF/9KsIFhpT57RsvCr0ZeT1tE2L
60zEwJLPPXUJEPqvcRMNia8LaL9wk1b9q4R8i0B2wKJhb3/T/A7WVmkhFBoynQqi
RR1rT6XrE7BKdojqaxBzcaMZwH2Kakhz75T/DhSL8gu1oXSVwp/QsqohWoC/X/IH
rsMi0sOKAJGluYxF3VBngGLZzAi7hhvx2sKhQOpkUNMfdsNZKzqYjJrxdUFvKUwr
M04ZQmwCAoqUF8ojmKx9KmXMx1rgroVD4wQn3gi64DpuytQ6in+m6caaBAALqxL3
0/5SEDSy74xOAxOstu868ax654ckonshCH/6smYy/ZJ0846buXJizLdbPEi29mkO
HZc02FIvww0f9q48HGfSYEJxnhFVOlThOroVPM7i3O5DEhsdOnExy6YEv316LylN
FFBlhiX4cO7G2c/+3TNx
=wiRz
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
