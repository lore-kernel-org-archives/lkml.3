Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaGNQUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:20:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43375 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaGNQTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:19:24 -0400
Date: Mon, 14 Jul 2014 11:19:18 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org
Subject: Re: [PATCH 1/1] ecryptfs: remove unnecessary break after goto
Message-ID: <20140714161918.GA15828@boyd>
References: <1404837007-7089-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <1404837007-7089-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2014-07-08 18:30:07, Fabian Frederick wrote:
> Cc: Tyler Hicks <tyhicks@canonical.com>
> Cc: ecryptfs@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---

Thanks. I'll get this pushed to the eCryptfs -next branch.

Tyler

>  fs/ecryptfs/keystore.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 4725a07..8f0d619 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1846,7 +1846,6 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt=
_stat *crypt_stat,
>  					"(Tag 11 not allowed by itself)\n");
>  			rc =3D -EIO;
>  			goto out_wipe_list;
> -			break;
>  		default:
>  			ecryptfs_printk(KERN_DEBUG, "No packet at offset [%zd] "
>  					"of the file header; hex value of "
> --=20
> 1.8.4.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTxAMGAAoJENaSAD2qAscKEc8P/09kWHL7thzRSAq60JQql7Z9
sKe1QL30+gvj5BK+mKhWwrmhMsZHI/nzkXnXqP9LiIJO9ionycPb/oRoCkmcMHPd
jLwnXywznI1bJXYtXUtvJhMKyzPWCohUJfPwImvl+V6ylmjOouPLD7GNuavQ1jT1
RAq2hkvV/jX2UCRvumr8lZr5kAtnxZcy80OKppKq4D0NI6RUxzfE57okOd9Y6kr3
4LRsRJgrcs8OWV4l5zkEN4bGL4ASw/ZimVh/rU3z5AtEacpKnZUSLNcmBGS3pfLr
L4TnNnyMUwymbnbKeF4TsbOVRxdYq7XoX8hoUgwKK3KF/b5VtPgTSoudSvI7wXvJ
8V+0w13KI2zLYuYeHQynXVEJD+Xsf/QNX99BiVVaIrasyJN4yP5g+ZD21lyNKG4E
ZStZA+0bUF/TVm2/J/M+kpizacQO5+LJoJtLk1+fberY4QBdKLt+UD6xGY6n8xZs
+0cwDlauKiEZbbPZ4MYOlN95+wn35xVch1P8Il+cK36JYB2bt/fMAcAf7oEhpx/o
WA07sN3QDt+eKiGLyfWyFxRFScuqcjxR+RzSJNtD7xxSlfqt2Wfps8FpEiPxqhaX
gvppoHQIDS7L2JU1Xp2fqs9kAlIbHvM66c+XFzmpxZHPmzG01bu4C+SyMO3rDHR7
WTztAJyjMZq0ceM+tMuY
=boHp
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
