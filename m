Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3HAJxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:53:18 -0400
Received: from up.free-electrons.com ([94.23.35.102]:52617 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751108Ab3HAJxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:53:17 -0400
Date: Thu, 1 Aug 2013 11:53:13 +0200
From: "maxime.ripard" <maxime.ripard@free-electrons.com>
To: "kevin.z.m" <kevin.z.m.zh@gmail.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        =?utf-8?B?5a2Z5b2m6YKm?= <sunny@allwinnertech.com>,
        =?utf-8?B?5ZC05Lmm6ICV?= <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 4/4] ARM: sun6i: Enable clock support in the DTSI
Message-ID: <20130801095313.GK2911@lukather>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375195462-19566-5-git-send-email-maxime.ripard@free-electrons.com>
 <51F86A2E.10505@elopez.com.ar>
 <20130731073724.GA24439@lukather>
 <2013073116110750016327@gmail.com>
 <20130731114957.GD2911@lukather>
 <2013073120102496855035@gmail.com>
 <20130731154953.GG2911@lukather>
 <2013080108343040654547@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ICrdrp3pM9DyZLTK"
Content-Disposition: inline
In-Reply-To: <2013080108343040654547@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ICrdrp3pM9DyZLTK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

On Thu, Aug 01, 2013 at 08:34:35AM +0800, kevin.z.m wrote:
> > Ok, just so that we're on the same page, we have two oscillators running
> > at 32kHz, the internal being always there, and the external that could
> > or could not be there, and it's each different hardware block that can
> > be wired to one, the other or both?
> The selection of internal or external is a global setting for system.
> Hardware blocks =EF=BC=88such as cpu=E3=80=81twi for ex.) just see a 32kH=
z clock
> source, but they don't care where the 32kHz clock
> from.

Ok.

> > There's no global mux that could use either one of the two 32k to
> > provide the only 32kHz source in the system, right?
> There is a global mux to select internal or external, but no mux for
> every hardware blocks. I think that the mux need not be managed in the
> clock driver. It should be set earlier in the boot loader.=20
> And the selection is keeping either system is power-on or power-off,
> when there is a power supply with battery or DC. Because the mux is in
> RTC power domain.

Yes, in that case, we mostly don't care for now. Maybe we will at some
point if we need to add power management features, but we'd better
consider a fixed-rate clock for now and not worry too much about it.

Thanks for your help!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ICrdrp3pM9DyZLTK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+jAIAAoJEBx+YmzsjxAgzPMP/R3rGga915clXPy2nqOB2wx7
O1Ype8b6kpdAksyqccwDETNQG3IvZFxGHdptrJJI1tUW2qWPG0DHAx5FVqJMn4T+
UaaYD3XXkubfUDY73DMT0LX51VnfERZaoguYi7MpTEhZdBw1bGOXK7FKhlUCjuiM
PQW8wGKYmopE7lRBAV9DbdajpfNP3IPKoHYZjC2j3aYWldVw6l12kQOyjFT7nfCX
7lv9rMCeQzxa3zmfjaE0gD7+A0/Dbfk9/n86IPpgwIUik4ElduTxnJtIxzJKPMsB
4R1Nj/qJOWUNLgQkSxkwfeHSBc6baT4O6DFcjNKE+9IKA9t/p3na6kn3poyo1oHZ
8K0OBQenUVOFt6SIfZZEUmcBtHoC00/VH/45FjlO3XRSxy5GdA0SL9b6kMTjbdeq
Yt9TH3JG+cMo1nbpvNOG7Mg5DZPDwA2a+dKKzOf0x9pEkVlkF6OA5zYZSanlxiKH
9shjP/JeMuU9pc6HtdvsyteslrRP/Uwh7lAppjFA+yoaBmplxeYjQYYhIJhk8IqU
umx99QKcA9Uxm4AHsha8JDIH3MepOtJNH25mn7KI/FQEMmdJLppyhRvDdBrWxo5h
F0okyWYEGKP5CEYDUJGUcNn8prjfx2JbuXB1MBSkfY2qlLaYlmaNfIne12YgCIkf
m+n3SERxWKmlsGdv3gGy
=/UM/
-----END PGP SIGNATURE-----

--ICrdrp3pM9DyZLTK--
