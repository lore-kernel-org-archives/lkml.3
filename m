Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbbAYSka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:40:30 -0500
Received: from mail.kernel.org ([198.145.29.136]:54693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbbAYSkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:40:25 -0500
Date: Sun, 25 Jan 2015 19:40:17 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-pm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] power/reset: arm-versatile: Register with kernel
 restart handler
Message-ID: <20150125184017.GA29704@earth.universe>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jan 25, 2015 at 10:13:37AM -0800, Guenter Roeck wrote:
> Register with kernel restart handler instead of setting arm_pm_restart
> directly. Select high priority since the restart handler is instantiated
> through devicetree, indicating that it should be used if configured.

This does not apply clean for me. Please rebase on top of=20

http://git.infradead.org/battery-2.6.git/

-- Sebastian

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUxTiOAAoJENju1/PIO/qa6tkQAIt3Mxc8Li/gZxEU5h0PMWuo
JZcrIM20gRF9Il2ud+8+/zKjp7u5VaMNsAW86kahM/OTnaNBucO+1wmfVeyyN/p9
ncux/PHSkMR4n7e085eMKU8g0n0L7si8GRTRNMgl5au773OK//Onz2zhnWZZEIt+
NQ5u6tCdzBaQJmu8r5vomDHjQiE9raL/u4sHZfRwZkZpSCU81hAVKLALbyb7lMKq
0f96LwN0OSpVCpolXMrvtv1v9qma34v792QpRfPPtaZbyZN14ICPmLr9eTo9p8JT
Ki/GjL1lLFE2Sl0tKWAt9wHRSzEZqBFaRWm6sb4vzxpOfuQifYYktsRAlQtDn7La
iS3+uf/TwYJm0kO43DrSO8qM0ZEICNBXvTOe1GCbWXwBC7S7JSXXlt2RRdm7HYMS
JpzDxXcUQNbe7TRV4t1JMLOufhDgR/1GfzaA9CA91XrQm9Tf+Ke24CFS3th6WglC
dgk8TNffiru5XczhCiZGj9qhmjokwXgYaVfeQkm6jgAetZAhYQoLGQvKCsm2ceuU
QlUI6F1kC3YKYzBAQFsaekVSzEpO6+aghF3KKFX/UScF9KtV6R0WnL4R1qzu7R/B
+hoKp9JD2kVSCtYjcdpPrm5LYuIXS+aLkP5DNDxTUj0Cd/zqOKuoWPdocp//r4KO
FGsHqypg5rk8XsN652fR
=Bdhy
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
