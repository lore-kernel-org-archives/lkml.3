Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaCLQ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:56:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41217 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaCLQ4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:56:21 -0400
Date: Wed, 12 Mar 2014 11:53:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Felipe Balbi <balbi@ti.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: boot: dts: build keystone devicetree blob
Message-ID: <20140312165358.GE919@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394639330-1288-1-git-send-email-balbi@ti.com>
 <53208CDD.7030106@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <53208CDD.7030106@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 12:35:41AM +0800, Santosh Shilimkar wrote:
> On Wednesday 12 March 2014 11:48 PM, Felipe Balbi wrote:
> > Currently, even when building keystone only
> > kernel builds, DTB won't get build because
> > we lack a Makefile rule to get it compiled.
> >=20
> > This patch adds that rule so mainline kernel
> > users have a chance to use up-to-date DTB on
> > keystone 2 platforms.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >
> We have been building dtbs with explicit command
> instead of dtbs since it was just one dtb so far
> supported. Was planning to add the rule once more
> boards get added. Now with Lamarr and Edision in
> for next merge window, will do that post 3.15-rc1.
>=20
> > note that I just tried this on top of linux-next
> > (commit 69d5cdda16b3c9767b82d80b07edb9bb056448e3)
> > and, even though dtb builds fine, I still couldn't
> > get keystone_defconfig uImage to boot fine.
> >=20
> > It's probably my LOADADDR which is wrong.
> >=20
> > Santosh, what's the LOADADDR I should be using
> > for keystone boots ?
> >
> LOADADDR is same 0x80008000. You might have missed

tried that, didn't help.

> to configure the environment u-boot variable to
> disable higher address space switch.
> 'setenv mem_lpae 0'. Also ensure to update

hmm, that might do it. Will try after upgrading u-boot to latest
release.

--=20
balbi

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIJEmAAoJEIaOsuA1yqREFm8QAIgZEiDRPtHAgLAQqzKSZTIN
08Gk7vUM5yUoR6M69tpHFZsh8QI9YRDOKbsCfBLkv/3HpW5hGRNHafP1ja5F2Yd1
pvH/crhMMyaEB0+IAk+8Mkj3M+4PjdKRb/gGFBZf+kqKh1rmKgPVYxVle2ZReTAD
QRm8+NydWwscjGMFgGNv69nF0bS1tLBTJvxFtPMrqb63RzNyWs5VyyERAkoFURLg
9mMPWwleKylRnV3X5i8iXyFvcnte6jk0zADJtSsOyreFvpYqxYuEvy1XokIoF3dR
J3AeNaR8fC6l9FGTS5wWO1MmH6pYTVJc6p2BKvZobuDGa/elvI8qH77j3/5t1Qpi
vvqZq1c1QORG4gzX1IoC1QGtcTvq/qkAYNGu1DM0sndnZbWU3B9QPJGoUGyoaFfL
HnF9dXSrvbkpZHXg9eu39o/rKaYUWDspP1ACG0eL7cHoFVqbk07nOoX1yZx1pZz+
zvHaasivCv2BNijOt008hKxy+NUisVnyMpY+9xQs69tcgeiNUMyHrVL+ywrB+vd/
93WA3Mub9gXYdJVEb5zmYGqAFI80poMDinum9UPGWbZwW89+nQW6iHggVI5iBvXU
SA6WDm/sToi5kDVMg9vH2DTAbNzLo1tVJr5aYXuEuiplGa3blD/V87de7HJUXLh0
iP0jfhbOJdiu0NNTlJC3
=/93K
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
