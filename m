Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3CEObT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:31:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46452 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886Ab3CEObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:31:17 -0500
Message-ID: <1362493863.3768.410.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 000/153] 3.2.40-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Tue, 05 Mar 2013 14:31:03 +0000
In-Reply-To: <87wqtmq6sb.wl%satoru.takeuchi@gmail.com>
References: <20130304033707.648729212@decadent.org.uk>
	 <87wqtmq6sb.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9bOtDZSJiUcKliZRRh5/"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9bOtDZSJiUcKliZRRh5/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-05 at 23:07 +0900, Satoru Takeuchi wrote:
> At Mon, 04 Mar 2013 03:37:07 +0000,
> Ben Hutchings wrote:
> >=20
> > This is the start of the stable review cycle for the 3.2.40 release.
> > There are 153 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed Mar  6 02:00:00 UTC 2013.
> > Anything received after that time might be too late.
> >=20
> > A combined patch relative to 3.2.39 will be posted as an additional
> > response to this.  A shortlog and diffstat can be found below.
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

Thanks.

Ben.

> > Matt Fleming (1):
> >       x86, efi: Make "noefi" really disable EFI runtime serivces
> >          [fb834c7acc5e140cf4f9e86da93a66de8c0514da]
> ...
> > Satoru Takeuchi (1):
> >       efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" b=
oot parameter
> >          [1de63d60cd5b0d33a812efa455d5933bf1564a51]
>=20
> Thanks,
> Satoru
>=20

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-9bOtDZSJiUcKliZRRh5/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTYBp+e/yOyVhhEJAQqxixAA1CjyiE1po9v42dsAonTo+uPVpQlmXTmb
IGwLvf+mmO4bSpKnmEEZkTthVbtyGnK/cw9g9Y4XPqrAHAJVMPlfb1s8sveHCayH
NcyZnDJOwQVnU82P0iUfnX6f6yp/kHX6IiVkTANe+hx80z4q3Jjcfy+d40PWMjSt
ZWeV72Uc9xhTSx0Scy6dUVwsUORWPB6rzL8EzGDrslduttCHxPeLguXBVIXHCmPc
YrE1H/8sLqiLkajm0wzSA8qFPMdmhESwgfg2M1c/Y5woeYVVl9miXc1bGCCFFvoB
CkRCz7UvOrfsS7VROmi+w/yJ5AN24n7D7E8z75JDcXtpdWB9F9dbypPpLc82NcDv
mjQLQ6FUM/PlWQAEjtFPidNm9uNDJfG4Wscx1ktlwje1qNO89B61VyLNo+DTDQrr
qoMHzLZlyVM6AKurC0iMaEEAOztW//KizWDzgxc5vV8NaQwi3WOdoQop0K0lj9Fe
RM3KqoAstjwtAVAAV5VJIhWKSYNzr/jQtQWDb8wnFYcrArxX/ThpNsn41H40hPAx
V01/uu4i0t71nF7DoQFsgbb5g31+JUtcuQzGrxObjr/Rb2DrABDlYCtRIQUabrtX
o1nkGRJOCcRU/TpTNejUDOSFbYwxP4Lquj1jO+XBNn5/SEkKtIhUhFbIvCUAcf+k
qXx0Sa4+GLw=
=ZeGM
-----END PGP SIGNATURE-----

--=-9bOtDZSJiUcKliZRRh5/--
