Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaBXIR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:17:58 -0500
Received: from sauhun.de ([89.238.76.85]:38248 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbaBXIR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:17:57 -0500
Date: Mon, 24 Feb 2014 09:17:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        kbuild-all@01.org, daniel.lezcano@linaro.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH] avr32: remove cpu_data macro to fix compiles
Message-ID: <20140224081754.GA2617@katana>
References: <53060d5d.XcmAdOiLt1MCo6Y5%fengguang.wu@intel.com>
 <1393057709-17925-1-git-send-email-wsa@the-dreams.de>
 <20140224072820.GA9069@samfundet.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20140224072820.GA9069@samfundet.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2014 at 08:28:20AM +0100, Hans-Christian Egtvedt wrote:
> Around Sat 22 Feb 2014 09:28:27 +0100 or thereabout, Wolfram Sang wrote:
> > Having cpu_data as a parameterless macro can easily cause build failures
> > because it can be a variable name like in linux/pm_domain.h [1]. So,
> > remove the macro and convert its only user. Because this architecture
> > cannot do SMP, remove the whole SMP block, too. Only compile tested due
> > to no hardware.
>=20
> Looks sane, AVR32 doesn't support SMP, so this change should be fine.

Great!

> > [1] https://lists.01.org/pipermail/kbuild-all/2014-February/003252.html
> >
>=20
> clockevents/3.15 branch, mens what you have queued up for 3.15?

Daniel has picked up changes from me for 3.15, yes. Because those
contain COMPILE_TEST this build failure was triggered.

> I can queue this in my linux-next, and send Linus an early pull request t=
he
> moment 3.14 is released.

That would be the best solution IMO. Thanks!

All the best,

   Wolfram


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTCwAyAAoJEBQN5MwUoCm2AMUQAJB0tQDGvXL5XlQJocYsWtlg
NnsgohYPA05tpUsHxXEflpVMY2GdTHLvKD4gxgHqKGDZAZXtQxh94dBeQackiAI2
vwZdJafgrV/6DP4UqPCBNsMFg/N86J0nyd5ul9MxmD0JqtX9mAdv5hr3agzR2xiT
MkPgNQxoKZd/b24tm7/P9WdZv1aViX+wiBZEbikyuQXZC22Vz+0OMHH4DaapilzT
m7gLxyVimZwezSwuqQMus1D6O+XAt5ramxQmn/wlCzpE8OElp2/bFeICKGtlGi5T
ae7eR5QyNzG7GNrft4Gj0D4pNtqikeNUrRKSqC1+NPHtqVxTghK7OojrZZvLqEiS
ebd7R13AhLIIXqWls8JyhSa2+N6nT15ALjd23JyjbYj1NRgjdhBFW7WuhitE1dX4
ohloeWyqeI0rwrdmGbkd8D9h04mSeXVN012qSxDeYxs6Mvm2rnkOyLUm2HKRVBQa
1GKKQzoF01Md1M2VmvIw+p6PZjN3n2/4rON9bMOtVK5ejU5NVmfAVZv+PCuG58Rf
asmBDb+eE/MqSr9EPmv9imEuXnJkQ7PQG1jqFzES69AuEnBkaa62XPPuE+n32T8/
LrmG2Oe/LpnpOYA/OCOuKvCiRz+GPUq3z9e39iPIGoBHmM1i1QMc2W0IzaFZA27F
HqapgJB/93/Rq8qiroGB
=ya8S
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
