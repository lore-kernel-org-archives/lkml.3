Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3CYHuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:50:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31452 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3CYHui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:50:38 -0400
X-AuditID: cbfee690-b7f656d0000007e3-82-515001cc9ce2
Message-id: <1364197791.29882.5.camel@kjgkr>
Subject: Re: [PATCH 1/4] f2fs: fix the recovery flow to handle errors correctly
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 25 Mar 2013 16:49:51 +0900
In-reply-to: <CAKYAXd-999ACB+QNpOYXj=3WmH2OGYdrR9hpUn1WtpRCOJ8qiA@mail.gmail.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd-999ACB+QNpOYXj=3WmH2OGYdrR9hpUn1WtpRCOJ8qiA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-ZIR4ytBvMOqTRxIlyQUk"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zQ90zjAGBBi9+GFlcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK6O7bRpzwX/Jio/P
	j7A3MP4T7WLk5JAQMJF4deYoO4QtJnHh3nq2LkYuDiGBZYwSi04tZIMpuvj2NDtEYhGjxOGT
	F5hAEkICrxklDn6LB7F5BXQkZn86yApiCwv4S0x83sDSxcjBwSagLbF5vwFEuaLE2/13WUHC
	IgJqEhOepYKEmQUyJea8ngzWySKgKrHh4GKw6ZwCwRIv9v9jhFjbxyhx6tMEZpAEv4CoxMnW
	T4wQzVUSM9pbWSDuVJLY3d7JDnGOoMSPyfdYQJolBP6ySzzY0sQEsUFA4tvkQ2C3SQjISmw6
	wAzRKylxcMUNlgmM4rOQjJ2FZBREXFOidftvdghbW2LZwtfMELatxLp176FqbCQ2XV3ACGHL
	S2x/O4d5ASP7KkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQyJ2wg/HeAetDjFVAJ05klhJN
	zgdGfl5JvKGxmZGFqYmpsZG5pRlVhJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MJbs8dY3ic74t8SK7XLB95A2r41z39xzn3JC8Mi86slppsJ/TxhKvP2wna3knjNHlEajWjvj
	Gbd/H35rm6byfpboCpy0lO252JzZC/kj+K7KZp/5xv+5N8wyc22v6H5bM9OspNST7B7b9cTm
	bTCrOirT837jhFVx3M7L5Dx+7VJunLtI6mnieSWW4oxEQy3mouJEAP8vADkJAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAd0zjAGBBsc+61pcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGju20ac8F/yYqPz4+wNzD+E+1i5OSQEDCRuPj2NDuELSZx4d56ti5GLg4h
	gUWMEodPXmACSQgJvGaUOPgtHsTmFdCRmP3pICuILSzgLzHxeQNLFyMHB5uAtsTm/QYQ5YoS
	b/ffZQUJiwioSUx4lgoSZhbIlJjzejJYJ4uAqsSGg4vBpnMKBEu82P+PEWJtH6PEqU8TmEES
	/AKiEidbPzFCNFdJzGhvZYG4U0lid3snO8Q5ghI/Jt9jmcAoOAtJ2SwkKYi4pkTr9t/sELa2
	xLKFr5khbFuJdeveQ9XYSGy6uoARwpaX2P52DvMCRvZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGMFp4ZnUDsaVDRaHGAU4GJV4eAVq/AOFWBPLiitzDzGqAM15tGH1BUYplrz8vFQlEd7o
	e0Bp3pTEyqrUovz4otKc1OJDjBMZgeExkVlKNDkfmMzySuINjU3MjCyNzCyMTMzNaSmsJM57
	oNU6UEggPbEkNTs1tSC1COYoJg5OqQbGStFPf78Ll5ZsWOt7b4HWfkbVlJsLT6yQujF7b7Fe
	AtNaDQMOzoebHDV4GkqnXjb9URkv1WEqkS0t6ONWO3WV29r21dNYqoKNj1RsClcTVXSae181
	btfv0H3tW014dijtTdIpuMN6sbljrbPmwTdKPXeOtiUoNAYW9araevz6Y6K+tkD84WYlluKM
	REMt5qLiRACrOKz+igMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZIR4ytBvMOqTRxIlyQUk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-25 (=EC=9B=94), 15:30 +0900, Namjae Jeon:
> 2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > We should handle errors during the recovery flow correctly.
> > For example, if we get -ENOMEM, we should report a mount failure instea=
d of
> > conducting the remained mount procedure.
> >
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/f2fs.h     |  2 +-
> >  fs/f2fs/recovery.c | 46 ++++++++++++++++++++++++++++------------------
> >  fs/f2fs/super.c    |  9 +++++++--
> >  3 files changed, 36 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 5bb87e0..109e12d 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -1027,7 +1027,7 @@ void destroy_gc_caches(void);
> >  /*
> >   * recovery.c
> >   */
> > -void recover_fsync_data(struct f2fs_sb_info *);
> > +int recover_fsync_data(struct f2fs_sb_info *);
> >  bool space_for_roll_forward(struct f2fs_sb_info *);
> >
> >  /*
> > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> > index 2d86eb2..61bdaa7 100644
> > --- a/fs/f2fs/recovery.c
> > +++ b/fs/f2fs/recovery.c
> > @@ -118,10 +118,8 @@ static int find_fsync_dnodes(struct f2fs_sb_info *=
sbi,
> > struct list_head *head)
> >
> >  		lock_page(page);
> >
> Hi Jaegeuk.
> I have a question.
> > -		if (cp_ver !=3D cpver_of_node(page)) {
> > -			err =3D -EINVAL;
> > +		if (cp_ver !=3D cpver_of_node(page))
> >  			goto unlock_out;
> > -		}
> err =3D 0 is initialized to zero in the start of function
> Why have you remove err =3D -EINVAL; code when mismatching cp_ver ?

This ending condition is used to find the latest node pages that we have
to recover, not to detect an error to exit the recovery routine.
For example, the error conditions include -ENOMEM or -EIO, something
like such the obvious errors.
Thanks,

>=20
> Thanks.
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jaegeuk Kim
Samsung

--=-ZIR4ytBvMOqTRxIlyQUk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRUAGfAAoJEEAUqH6CSFDS9VIQAIm2DH7GWiR2iV2H5PfTg2hd
3Uqt5cdpdIqxXKc3DEjumSUjpkQmUBu0WolCMyDnq2H4r7jJ5W/rWP5tdILPJ6VE
FheuAFAGDdAi+02jrPC2QvPAv5xI9tiKIkbIy3F1J71ocMhd30okZuwZ0PsjH8H/
b7QMhpMGcgLf7lfNTqLZ7VciZwOPi5cfa7ISpArLjkwvIrMhS5SS7mJqgsFfS8H7
Qg6mlvHRGSKIhwERjdHSVms4kJMsMpAWhRkW5VwWKcOBEQzgYrnV6aoslr7kEPuu
XDZXa7+1cry4gcwS23GxdDeq7EY8aVAgjqJUmOD2QZ/wU1XrSLVgm2XJ5a1ap1OF
/S93V+EC2TMLzLdNXL2utqwO4NiH/3B56IPtAYn2HPDdXM5BptAh2kuvjadB5ymB
Q+ZPwEZonrvNtLgWIpsyo4osn/8/Ki5iNpm6jifyetIytTNx/aUQT/xudb+HiZ3Q
99WxgBK08ZXymKPIad7bQW9jaif45po53E94jwX9ovHjCAgTsi4NDRBBfiYX5eXR
cY3cpibeUGe02psx4ZhlEXo+CGenkXioPEbFnvOn8OmW2V6FmaocHZzOmN5fzzeD
lLwHCg5Kw6QsfDMj2KVNFyEyB8tzc9CmQ1oBbozrhMEebriFsYlD4tF8n6tEuecb
7WAqaLwwmM4v/G4ED6FY
=sBIl
-----END PGP SIGNATURE-----

--=-ZIR4ytBvMOqTRxIlyQUk--

