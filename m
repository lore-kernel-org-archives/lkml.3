Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3F1Kl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:41:28 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59303 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3F1Kl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:41:27 -0400
Date: Fri, 28 Jun 2013 12:41:25 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
Message-ID: <20130628104125.GG4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <51CC0566.8010302@redhat.com>
 <20130627094307.GC8437@lukather>
 <51CC0BC3.5090309@redhat.com>
 <20130627165436.GB4319@lukather>
 <51CC80E4.8060801@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Content-Disposition: inline
In-Reply-To: <51CC80E4.8060801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Thu, Jun 27, 2013 at 08:13:56PM +0200, Hans de Goede wrote:
> >Siarhei however notes that even higher-end SoCs like the exynos5 have
> >similar performances with that regard. So I'm not sure we can do
> >something about it, except what is suggested in the above mail, which
> >looks rather unsafe.
> >
> >Anyway, like you said, we have no easy other solution, and we lacked
> >such support until now.
> >
> >So why not merge this code for now, and try to optimise it later if we
> >find it's needed.
>=20
> That is fine with me, I just wanted to share that this has shown as
> a bottleneck in some benchmarks in case anyone has a clever idea to
> fix it ...

And you were right, since I wasn't aware of such discussion.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzWhUAAoJEBx+YmzsjxAgpY8QAIHrB0oY7gtAJ0Y3k9XU9qeN
gilSHsJZlH7iZ2gQ0Gpilk8kQnoVf/hAk5s/b+jYJimAqw9YUOgCF+e/SfVnFE6S
jDwxnQuwxOwwWyCWAFyJQZIUzo9PerM2EZf6dI1f7gy08IerB0c+UDvdoFVBXFFr
823zNFVtoZxGzgzO6E953uQvA35O0mSst7s0vSQ+WTypkqsL39rULWsjFp9SPPDh
VTDSIXRTPshjkd5ISXos/P3b+CKt974S/O/ZORjTg7/u8dapshIVaWB6espNWy4X
39TWKpDnKTqqaVhtE/VQ2U4nEjh+oeuYtE/liBFy0Y/POdVtxc3UNE8m0bL8X/AY
nXYTtDqU7ZkC4WdZ6paiKE8tkqs/WqRm6L8Iifzp4klIonJeZE4COYlJ/GUotfwo
Xw87CtBgNG+ubycYRyo+KkByDRNgmgaTYdaIEjd2pLuw112ZnPdfXPUZvzsqI6Xc
hXirMzw65qCgvWxX9a2Edn3Ecam938BaReze5zDkFzx5k7xpkFIIWn50RoBkgyg7
l4oHXKbPkDW9qimYKcxeToEjzXTVw77iqdTGzwjl3j3IeWLCb9jP7xCkpirKTMp0
uW2ft2CnOjQ5EhUgANjiiuWOI6TFKaf8AfARN5YEX6m9828EmIAYg46Ktakzc94H
YSCg6WLPlgBtFLv1LRPD
=Yfgf
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
