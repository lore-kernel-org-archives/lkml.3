Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3C0ATX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:19:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22087 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3C0ATU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:19:20 -0400
X-AuditID: cbfee690-b7f656d0000007e3-c2-51523b07e226
Message-id: <1364343513.29882.7.camel@kjgkr>
Subject: Re: [PATCH 2/4] f2fs: do not skip writing file meta during fsync
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 27 Mar 2013 09:18:33 +0900
In-reply-to: <CAKYAXd_z6oWgrRj3dQ=_OieZ1twnoQqhGLaQah5rp_j9ge858A@mail.gmail.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
 <1364168414-12815-2-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd_z6oWgrRj3dQ=_OieZ1twnoQqhGLaQah5rp_j9ge858A@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-RAHnHxpGeYgPh2Fbqe6a"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zfV1266BAgwvreC2u373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlbFz3RzGguVCFe9u
	LGZqYPzC38XIySEhYCIxd/sWdghbTOLCvfVsXYxcHEICyxgl3k6ZyQxTtPTcfVaIxCJGiZ9/
	FzFBOK8ZJd5s72EEqeIV0JG4OWUnG4gtLOAp8e/mU6BuDg42AW2JzfsNQMJCAooSb/ffZQUJ
	iwioSUx4lgoSZhbIlJjzejIriM0ioCrRsWgJ2F5OgWCJ59MhbCGBM4wSa7p8QWx+AVGJk62f
	GEHGMAtUSZw7GAlxppLE7vZOdohjBCV+TL7HAnKlhEAjh8TzR3NYIOYLSHybfIgFpFdCQFZi
	0wGoFyUlDq64wTKBUXwWwtRZSCbNAjtUU6J1+292CFtbYtnC18wQtq3EunXvoWpsJDZdXcAI
	YctLbH87h3kBI/sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJConbCD8d4B60OMVUAXTmSW
	Ek3OB0Z9Xkm8obGZkYWpiamxkbmlGVWElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwZvSsz4m7wlkcEfW+eRU7b5lzzryZGTk6HJfU9DdXm+TFBYjEP+U4r7dPz07E4OREtkat
	VLFDMXe7ztypNA9N4SxVePt1yf2Id/F/lVTnHmRw3/P3Ot89lSUsnOUnAnWf+M1yMdSNDGDY
	731mqtXu6bwblyqnFc6ozf7V53RLkn2llSSjY6cSS3FGoqEWc1FxIgDgW2ApBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jAV1266BAg+cf2S2u373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixc90cxoLlQhXvbixmamD8wt/FyMkhIWAisfTcfVYIW0ziwr31bF2MXBxC
	AosYJX7+XcQE4bxmlHizvYcRpIpXQEfi5pSdbCC2sICnxL+bT5m7GDk42AS0JTbvNwAJCwko
	Srzdf5cVJCwioCYx4VkqSJhZIFNizuvJYLtYBFQlOhYtYQaxOQWCJZ5Ph7CFBM4wSqzp8gWx
	+QVEJU62fmIEGcMsUCVx7mAkxJlKErvbO9khjhGU+DH5HssERsFZCFWzkGRmgS3WlGjd/psd
	wtaWWLbwNTOEbSuxbt17qBobiU1XFzBC2PIS29/OYV7AyL6KUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIzglPJPawbiyweIQowAHoxIP7wyGoEAh1sSy4srcQ4wqQHMebVh9gVGKJS8/L1VJ
	hFdwY2CgEG9KYmVValF+fFFpTmrxIcaJjMDAmMgsJZqcD0xkeSXxhsYmZkaWRmYWRibm5rQU
	VhLnPdBqHSgkkJ5YkpqdmlqQWgRzFBMHp1QD4450ee2nfNy2myvzDsimzsjIV8uc5bI5XPbe
	n9m8zYwrK7OrXAotQ5f8L3uys6xx9QHD+P5rKevN4j5YWJnfWdDntKppR95SK4ned9onZ6np
	hrxV/ryhMI9T4hXv3iMG922L0p9EvDjN6fUjqFZe1LqgxvrO6QlfnVh8Vwi8+alYMK/wf3CJ
	EktxRqKhFnNRcSIAjdFAwogDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RAHnHxpGeYgPh2Fbqe6a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-26 (=ED=99=94), 09:48 +0900, Namjae Jeon:
> 2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > This patch removes data_version check flow during the fsync call.
> > The original purpose for the use of data_version was to avoid writng in=
ode
> > pages redundantly by the fsync calls repeatedly.
> Hi Jaegeuk.
> > However, when user can modify file meta and then call fsync, we should =
not
> > skip fsync procedure.
> I have a question.
> Which case does user can directly modify meta ? Recovery tool ?

The meta means the inode information like atime, mtime, size, and so on,
which can be modified by setattr() or something other vfs apis.
Thanks,

>=20
> Thanks.
>=20
> > So, let's remove this condition check and hope that user triggers in ri=
ght
> > manner.
> >
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Jaegeuk Kim
Samsung

--=-RAHnHxpGeYgPh2Fbqe6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRUjrZAAoJEEAUqH6CSFDSDssP+wcggqIsmwMt5QAo2GGaTKOA
UopXmXFJ+CvgqE0a1vN93gH/BIhf/tnbU/ToH/IrtfbCpOxZ4KjoFIE36Y7NBYix
abgFyRiCSBMePgscutQeRnSVzimr9JJhfY3Gz18lL8ZF1jN7JTYy8nQtZP0BrC7H
JsaguK6wD2aNtEW9WtIvRK3HmCqR66dvM15eaclJ04BXD8/JLODnbGr3WpSqcqzn
lBQUlQ/mMymDVNNap3cZpxBSgSynTVp7hBLLiiFxNMqlI666AbmFZ+MhhacT0A+U
2ufxkG6OCw8H/+kYEkyBDrgZaC6F37TTIlaiqoqt5HQwKIn+52B74RijMHWFn15Y
VTWs47XZPmv578VZiiJVNiYaKdx8+Lf90lEGNk56zAtZP/NpK/XZhIdDyVwCh+s6
/NQdiMqmdtyZMLSZdjDJEnN/3QDC/MKiA5HtCcJssGHImfV9XkDSP+1/Kdu/Yv6e
RpEyQzlXLOJ4l1y8V23dkMk57WfPJZzugdOIB3lVHHr3feqS6gOMgj6TUAdRwDcl
k++8XD08lhWzUKeGIiq/xK73VFhUkRzO11P93JMJ7kCwzGyt3y62UkEnlPrxOzmW
9kMsO6K4/SdI55m3vWcJJ9nd2QosXRpd93FYZtZyG/UxxJBnTeYI39sCXnnAyySh
0OIdwC+6bcag00rkiJ34
=NLu6
-----END PGP SIGNATURE-----

--=-RAHnHxpGeYgPh2Fbqe6a--

