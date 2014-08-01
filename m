Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaHAQQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:16:09 -0400
Received: from sauhun.de ([89.238.76.85]:37741 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaHAQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:16:07 -0400
Date: Fri, 1 Aug 2014 18:15:57 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
        pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
        gregkh@linuxfoundation.org, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC V8 1/1] clk: Support for clock parents and rates
 assigned from device tree
Message-ID: <20140801161557.GA3277@katana>
References: <1403105372-30403-1-git-send-email-s.nawrocki@samsung.com>
 <1403105372-30403-2-git-send-email-s.nawrocki@samsung.com>
 <53B59221.5080100@samsung.com>
 <20140725214231.5177.86866@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20140725214231.5177.86866@quantum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 02:42:31PM -0700, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2014-07-03 10:25:53)
> > On 18/06/14 17:29, Sylwester Nawrocki wrote:
> > > This patch adds helper functions to configure clock parents and rates
> > > as specified through 'assigned-clock-parents', 'assigned-clock-rates'
> > > DT properties for a clock provider or clock consumer device.
> > > The helpers are now being called by the bus code for the platform, I2C
> > > and SPI busses, before the driver probing and also in the clock core
> > > after registration of a clock provider.
> > >=20
> > > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >=20
> > Could someone please take a look and review that patch ?
> > Any further suggestions, ACKs/NAKs ?
>=20
> Patch looks good to me. I'm happy to take it.
>=20
> >=20
> > I would appreciate a DT, SPI or the I2C maintainer opinions.
>=20
> Yes, Acks from SPI and I2C maintainers would be good. I might need to
> drop those parts of this patch if they don't come through :-(

For the I2C part:

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2708AAoJEBQN5MwUoCm2aCYP/365qBaTpbuWjzeZ1mlBEwpR
3/qVH7fE0MfwEHd03BafDmNAf3rV3zTdQjvTyz3w7eH1Tvwf5nWJr3Wgqltkp5iU
Dcm4FUO6r17Fae+bZLO88By7UOm8WccZtsI8TorQTruGanCVZbavul/AvJdDX7ck
ffhNzao4AMuQdjFMz3FQr7kkGo3GpveC3tmNhK4aFnDWsleEgNvQ2NvaRLdz6wbe
OTxk42sIJtG7iKjleKz2xthCp6R/AvhdU1O6SZCKmskpmZW3eHp6107WuCqd0IMr
ifs9cwEK62iqVAix0cNp5GxmsOpEUBtExk2RAxTQMGCwFePPu4BI5iXYMYuDXbDl
4xHzLoSr0wbCW8EGl17+Pd3i+llfjgZxvKIi0DUOh6IeuvWtB8sVNA6h1+6w3VTi
DmUOEBcdbpNR1y0OdszrApcP5CJYbYlFzUYWfVn+MV01nj9lNaAwGB2ynlk2CpMI
r9u0PbShD9lib5CgbO/rbQqSJfG+o5rjlzP/YtTw+InVZQT+2OQqYh/RxsKVGjcE
9SHHRKesGwBhiDtLS5oRTI5GakkYjqg5+euIFKcHBshmoTgf54BiWAV4WATKuxwT
gjcfbiUHdTDJ6+z2klekmIelujnlAMgAoKcksb0toRkMXZbq91bqB/ytak6/wHEG
YtLYHZZiHTwejG8qi5jm
=mIbT
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
