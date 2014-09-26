Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422631AbaIZUZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:25:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:53139 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbaIZUZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:25:30 -0400
Date: Fri, 26 Sep 2014 22:25:23 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Cartwright <joshc@codeaurora.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v4] power: reset: use restart_notifier mechanism for
 msm-poweroff
Message-ID: <20140926202523.GB27687@earth.universe>
References: <1411644831-2931-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <1411644831-2931-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 25, 2014 at 05:03:51PM +0530, Pramod Gurav wrote:
> This change replaces use of arm_pm_restart with recently introduced
> reset mechanism in Linux kernel called restart_notifier.
>=20
> Choosing priority 128, which is default priority, as according to=20
> documentation, this mechanism is sufficient to restart the entire system.

http://git.infradead.org/battery-2.6.git/commit/18a702e0de9879d5c0225a09f49=
4443f0b91a0cc

-- Sebastian

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUJcuzAAoJENju1/PIO/qavv4P/1WKpZuxgWjdfStheOI1Ngmn
aE07N3sVc90RTp13LFhs6on/vGHS1ZmB4MaD/v9T4Z9in4dNQYSrKGmzcx81MlDx
j8j9dybTm5W8TMhAhplPYA4PBaQX4iWGZr5uOCB3XZsoS6x373VhgWonG0Ln6NVD
W+NlYhdur0vs8kI+eFwAPfa3xvPSkk2+k1w41BUYsNiS8Hewwc60p0dmbDaB5dqi
PzBtsqZV6/Q4kfTKMPp7Boz33fw2I3dGySkc4CN7PF1pxioZzgu7D4UUPL77yezb
k+B46Y32WHTZ0jxhXPliNBo1HUZaodQq5d/u4TUhMuSIX+WFxvJJ7lw/q8Poxw4r
hCBARlMuYIUyGTip60D8m7ZLpFy8aLuhoZWpptGQqT6D36XILixl/jmFU5XSrBm/
mKMbkewxS8T49Hw22nVCGVWcbk6MS510tI8yMwcqYBKCcR0HBAFqBp+Eth4YgU/j
nk+bdQf9NRBFZC53JRPAA0M+gJ2xU3o2KktkGS3QIXy7p+uyrrxIFV5ua/HOoSWJ
c9VgFqXcdqAJy2le9p2dnHplBN86P5Q0Oqm+xnoiPWyIaFyVHtjq5xyLeDARYlcB
6tJql7FHkZBQqLH9HBVd9YIpIx9GpVaUF7lElmVthYcB0w1dwr7ldt/Nd4nEjuYw
iNm2J5oLWFncovkDfwAD
=o39E
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
