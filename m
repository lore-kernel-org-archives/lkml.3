Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaDAQnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:43:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49991 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaDAQnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:43:14 -0400
Date: Tue, 1 Apr 2014 17:42:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com
Message-ID: <20140401164254.GA2269@sirena.org.uk>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
 <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
 <20140401120715.GR2269@sirena.org.uk>
 <20140401132156.GB27586@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2GxxjMFQpcQtANqJ"
Content-Disposition: inline
In-Reply-To: <20140401132156.GB27586@MrMyself>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
 for Tx and Rx streams
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2GxxjMFQpcQtANqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 01, 2014 at 09:21:57PM +0800, Nicolin Chen wrote:

> Sir, I just rebased my for-next branch again and found that it's missing
> two applied patches: "ASoC: fsl_sai: Add isr to deal with error flag" and
> "ASoC: fsl_sai: Improve fsl_sai_isr()", so that's why this PATCH-2 could
> not be applied against it as it needs the macro that's included in the
> patch "ASoC: fsl_sai: Add isr to deal with error flag".

Ah, those dropped out of -next due to the merge window.  I've applied
your new patch now.

--2GxxjMFQpcQtANqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOuyLAAoJELSic+t+oim9P9IP/juYeCYWLrvNjtoaolEc7fFY
Le8Ot6PwBTjERsdn7oILYWk7ILfFY0UL5umC+41/KvOUdIf1ngRF+UbLaqOLqN0m
vzxiQYmfeIqpgPqgU6V9PDXxnjhNkU827OyC++BmR4/hYBXn4lOBwUTa9Nbn3UU8
0QJy/LkRbPqhIJLhme1E2hMePJghqCP4sKc3pqtDYJ4E1LrKvFb26kV3Qs/R7zgd
dpaFtLpw8EjTpi0PAsYktqZOuAHXPz1zP2aK7TOR+9jPZnOs9H4PCpv6J/mfWitI
Fx+mQ5bU6ZHX9QnyZGICeT4xkx4rI99ydbO5jSSRF6RKMX/axVOhS+B1/kyHFjpL
tICQvHsD4ZgMdd7Bgj/ysQr4iczCkGxQ46jutg+kZmc4OULrashKTzZYD6nL0tLU
xjTsTQmhyiQVAiCogaftKeLA7eUSyID2RJNKodPH9FGJECWlcT0Ea5Qlz2prWi1o
wL+ATn1Mr10VMgwcyp3MmHRSyWT7MHY+pSDmjUP2t1JGF9/vhxPuMZQvlVXvQjrd
kGGtF/ctijt+j72z9oPZacIgD4d+mUM5A9lHRFtb3I9vihFm2I/csdu6nbfsNkhW
0f2IUW7XxlZglfPjyRgxxbpv5qwbUhDKS+pBYAtL0+gmav3o9HYdPpnVUS9MgdpC
Vd1ZoH2izNV+v8a0j5vO
=9QgJ
-----END PGP SIGNATURE-----

--2GxxjMFQpcQtANqJ--
