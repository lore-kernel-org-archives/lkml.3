Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3BFERX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:17:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58639 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183Ab3BFERU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:17:20 -0500
Message-ID: <1360124227.32217.20.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 000/128] 3.2.38-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Wed, 06 Feb 2013 04:17:07 +0000
In-Reply-To: <87622887nw.wl%satoru.takeuchi@gmail.com>
References: <20130203144644.035172954@decadent.org.uk>
	 <87622887nw.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-c3eje9aXPmay2JXQZRrw"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c3eje9aXPmay2JXQZRrw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-04 at 23:39 +0900, Satoru Takeuchi wrote:
> At Sun, 03 Feb 2013 15:46:44 +0100,
> Ben Hutchings wrote:
> >=20
> > This is the start of the stable review cycle for the 3.2.38 release.
> > There are 128 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Tue Feb  5 21:00:00 UTC 2013.
> > Anything received after that time might be too late.
>=20
> This kernel can be built and boot without any problem.
> Building a kernel with this kernel also works fine.
>=20
>  - Build Machine: debian wheezy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
>=20
>  - Test machine: debian wheezy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB
>=20
> I reviewed the following patches and it looks good to me.
[...]

Thanks.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-c3eje9aXPmay2JXQZRrw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURHZQ+e/yOyVhhEJAQowmhAAv0MB80wzY4hsVtz8BINeTLcltPbSTkpX
zudIr6ti2w3ATEWuXiKypRNhV7rnNFpml5DAjAF7BCNGm4QCa5QbxI84ipip33vJ
jhWRoWpQBc0eUNhQVdWPm3X5HZ0m+xR0k/a/+QY7zzkgasBJe9nYpuepdP8edU40
i2TzuBTFilP2Yaf1bowPbw3pfBkN3P4tGa0BLsWQonVnnKOpUGGwyutHXBAnqb2Q
D8e22B8pbv0/vMudXi6WfPnKNhMLw/n10m1ox2bKamyYhun+VZQWC1kTBFODiTJv
XRzJ+CL2mniFVr1Wz9hOa42Uej4BAh+5/MkTimtgpWdGjm4+WuGXg1q4IxAPMEJI
wYonTOckNGTDjYoNPN0mznTu/NqifVeD8M9aO9RFPCq5GkYxe/p6wL3CDWbQJ8z/
EK22z4Rt8LFiO6PnvZD61hwveg/kof+zkMDHWtj3jHq6q1Rb22WQpOw3ChJcDIKM
snMwmNWK0z4ju7xBhfeo919yc8OG0lwSD0//hbc96KuPL/sIrGPEl3goRfAZQcjP
eR0wVecXTnuLwHV4NIZDUWLbsYyB4636bdFYS08SI8ND55OcoBDnI92rjtqeN/kI
+t7OCuEb1nOfKnp9K5ZpjUMpyS+BlDRT2/1huRf6q4A79BGpDUU4ZYYjI5zmskwH
8oFYKfLuNoI=
=tsO7
-----END PGP SIGNATURE-----

--=-c3eje9aXPmay2JXQZRrw--
