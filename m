Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3HBIEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:04:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33132 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3HBIEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:04:24 -0400
Date: Fri, 2 Aug 2013 11:03:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Greg KH <greg@kroah.com>, <ksummit-2013-discuss@lists.linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130802080335.GM24465@radagast>
Reply-To: <balbi@ti.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731123351.GA30474@kroah.com>
 <20130802075352.GY7656@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fDP66DSfTvWAYVew"
Content-Disposition: inline
In-Reply-To: <20130802075352.GY7656@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fDP66DSfTvWAYVew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 02, 2013 at 12:53:53AM -0700, Tony Lindgren wrote:
> > > Basically the data bloat issue is there for the arch code and drivers
> > > and may not show up initially until things have headed the wrong way =
for
> > > too long.
> >=20
> > What do you mean by this?  You seem to be very vague here.
>=20
> People are unnecessarily defining registers in kernel for similar devices
> over and over again for each new SoC at the arch level and now more and
> more at the driver level.
>
> One example of that are device tree based drivers that don't describe
> the actual hardware, but instead have a binding that points to an index
> of defined registers in the driver.

-ECONFUSED... DT passes only the base address and the size of the
address space. If some versions of the IP have slightly different
register layout, that needs to be treated at the driver, right ?

> One way to avoid these kind of bloat issues is to allow drivers to load
> data at multiple points: Only abtolutely minimal set of data should be
> static, some should only come from the bootloader as a device tree or
> ACPI tables, and some is best to be loaded after booting from /lib/firmwa=
re.

why would we put data blobs in /lib/firmware ? I know we have discussed
this at some length before, but I still don't get the idea that, just
because data shouldn't be in the kernel, we would bloat /lib/firmware
with blobs which aren't really firmwares.

It would be like adding ACPI tables to /lib/firmware :-p

--=20
balbi

--fDP66DSfTvWAYVew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+2fXAAoJEIaOsuA1yqREsYoQAKAPQ0K7FMedYpr2tACCH8Rt
H96b//k9FGxLWG+e6S400d80HeR1KaXadb4ptTMljIMIm3jc98DJFxvRnWJAtiUp
LSqu+Xrw5UFSIj9a0TliS00pdV4Hsh3glQFWV6l6R5uBEby1iKQS06wsUy8kZ1cz
azIia7wZBPSPa2uDf3U7m523YmA5lCxKg7H45FimVPrCu4m53Ta504JVZBGlipKT
/4ulata68keF29Mq5KJCJKg86dSIRpI35g8O1QuT0PviCsDD2mCWNMJDlKkVRiaE
39Hv6tvR/P7yT02UNM3D88uI8nqUs79vXc7kePIzjpsUb12ItYvf/+X9I9YVP5eP
FRL2IQuAPaYUheyLWi/sglBwJW0DOOoHU1EAMLsNyLz8aPChgO6KLTzkdH9wVJ7Y
/uCtgcSKTWX81m7V0+jmBiGvZ1aCEcXYxa3xT8pssUkc2A9T1u8wF0xCaEJ6AKfF
DbGy/vO4Q/O9qsNNj+f+9ahQNEsgOfnK6yiQF3pZO+XuBN25mWz0ijyUhg8josdN
oounGZ3SVtKVHFZqtQGbs/KT4ectOG6rnGrYkz7HWKh2eSvUnASKBwFUfiD2Pt/n
JH+HnfpdFE3GUSxGqhoILWRwtkmTJiG2YZoKxzw+azb+6HpN1UEEusLdt2rMDHlx
kJzfARNeZhB/GnJYKRLK
=jBsM
-----END PGP SIGNATURE-----

--fDP66DSfTvWAYVew--
