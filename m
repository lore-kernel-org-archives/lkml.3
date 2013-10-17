Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3JQNQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:16:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab3JQNQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:16:19 -0400
Message-ID: <1382015769.3267.17.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/48] 3.4.66-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Date: Thu, 17 Oct 2013 14:16:09 +0100
In-Reply-To: <20131011215619.GB9941@roeck-us.net>
References: <20131011193637.253208688@linuxfoundation.org>
	 <20131011215619.GB9941@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iotdHtZYv4mm2OUfyJIE"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iotdHtZYv4mm2OUfyJIE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-10-11 at 14:56 -0700, Guenter Roeck wrote:
> On Fri, Oct 11, 2013 at 12:36:07PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.66 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Sun Oct 13 19:35:35 UTC 2013.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.66-rc1.gz
> > and the diffstat can be found below.
> >=20
> Less than perfect test results:
> 	total: 103 pass: 83 skipped: 10 fail: 10
>=20
> New failures appear to be due to:
> 	'powerpc: Restore registers on error exit from csum_partial_copy_generic=
()'.
> which causes six of the powerpc builds to fail.
>=20
> qemu tests all pass.

I just hit this with 3.2 and I think (not yet verified) that this patch
can be backported by changing STK_REG(R14) etc. to STK_REG(r14)
(lower-case 'r').  The register ID macros were changed in Linux 3.6 so
anything earlier would need that change.

Ben.

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-iotdHtZYv4mm2OUfyJIE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUl/jGee/yOyVhhEJAQoAyg/+IrMuIl4HBYAGJh6l8TCd9pNzM3cwi40l
XDPdRXkDwEKei1J8Q8NMzzcLVDI5ofAV+oBc12B7cjOM2lIp0CzcKXL4a/n9vxd6
kBX9BjA5BBPIm71LWzrzCbSX7bTYSO7yifEWLmFHemEWbwYle48UQtCJJ95U/X+s
zGFWFxibR0sOa4xD9wesCIG5UFDB7GbKSYP6rfkyLKb1BeWXTNlGdcuawpRAybVK
TRHN7HDGg7E927Q5e5whM6UOsdvvu7/QoIMKRp02YNUJDhA24yTmUAx3Mu/sVL8U
SZfev6BFUt55dV8yJCp0XbpgJ1r1Pz+QxBvreg0knAMk+qzSzCUEf/FYZdR5ks4M
Y7BoMnP39mjurVonbLcvMlZ4RvQu2tDUMVaC5m2y4QncmCoKReKwoXPwbnQRP5SI
ALES1g7KjCOmBBb3ppKfpJoBHG9qNgBVcI2E1el7J1CPp+iHNrizPXMNzB965OIM
vZoqbuIkuT0FFedUJXfb+sp++NY4ypm7QCEu5EcjyCF/vi8mfaiIY6nO8bc6B7YR
/TVLNlhS9/u47UyGudUZ1wDs1zYJnSABxIT+gC34xF8DdSs6Gy9nymqxZpMQodPi
q2VO7jzZWNZTgdNI2lssnxYnQjmwbQDHsrTcCoejPljWGGk/Aw6KEU+oR3ZC9WuB
ffSqMVgZtoA=
=BK5r
-----END PGP SIGNATURE-----

--=-iotdHtZYv4mm2OUfyJIE--
