Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3LCWLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:11:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:2409 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab3LCWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:11:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,820,1378882800"; 
   d="asc'?scan'208";a="393823541"
Message-ID: <529E5833.5000901@linux.intel.com>
Date: Tue, 03 Dec 2013 14:16:19 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, mina86@mina86.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] usb: dwc3: implement gadget's quirk ep_out_align_size
References: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com> <1384290286-21432-6-git-send-email-david.a.cohen@linux.intel.com> <20131125210614.GP18046@saruman.home> <529CD206.5080605@linux.intel.com>
In-Reply-To: <529CD206.5080605@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="duDodnWiEem48ELcoKAi5f5mL8oMlT72b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--duDodnWiEem48ELcoKAi5f5mL8oMlT72b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

>> This is why I have been saying that gadget driver *must* be the one
>> hadnling this issue based on the quirk flag.
>=20
> Thanks. I've seen different point of views in this thread. Since you're=

> the maintainer, I'll resend the patch following your directions.

Probably you want the v5 I sent (disregarding the v5.1 4/5 amend):
http://marc.info/?l=3Dlinux-usb&m=3D138420082526804&w=3D2

Br, David Cohen


--duDodnWiEem48ELcoKAi5f5mL8oMlT72b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBAgAGBQJSnlg2AAoJEGU5KLu7JjjxKgUP+wW0ugnKw4NYss8gVjlQobtn
9vFIrTaFOXuYuMGPxKXYeuEVfvql8ZfWlnH03oiXklvj5ZBTcPVnwfQ2znENGrpx
jefcweZRDY/jkocJ2HYp/2VPjWXxw6jJX9nsybqQLDd4wNdOUIEM9q8uibiiWV5D
SBV5N+Wx6Yb1fsfU+JdXq74uJJSZ3wjKlQFCY80XBvzUAGZ8wZsk8nitG/hSnGC+
stZ9+nwpLRl5jFwf1I4S97WnKESYJGdm7yLZ3AFFGw9az4jdCCciFlYCqDFjPyaa
PpK2Is9WE0SDrawennuTNO4RpnRWnNuDyw5VFc9wiZfI2kMKo2N+nmm81shUl7Yd
8wiQQ6HETdd+R0c87Ir9rX7mmnjWqm5kNx4VclPwdmr2923iOmO7+th60c+qW+xV
XdgojY1l8pN1bef0Gqy2Nob0kUkZeNFIJTH1CKUMUExaluPkdwdi9rhX7DA6gEvW
jlrqXpN4EyVT44r7ki819ZYGN1ueN9oOk8pqaAhJKn7eHN8R77zftPgvty+q1xk3
3+LO0IvWQGhuwgnhtRKUZSYj++Yp3v9K+wVkiB1wnleKhrmpQRLZjY4hEmrwuO1u
bDq+8sWf0SFwdS5OTRehgo953JRGZmG/fCGF8e9oYjSoUGbJswNSrV/jWxS1218m
aH/B5FaF6v38hVt0iLaz
=UpD3
-----END PGP SIGNATURE-----

--duDodnWiEem48ELcoKAi5f5mL8oMlT72b--
