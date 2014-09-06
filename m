Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaIFO3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 10:29:50 -0400
Received: from libra.uberspace.de ([95.143.172.171]:44138 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaIFO3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 10:29:47 -0400
Date: Sat, 6 Sep 2014 16:25:34 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Omar Sandoval <osandov@osandov.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm: sort.c: fix coding style
Message-ID: <20140906142534.GI28079@fu>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1409993977-4383-1-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Content-Disposition: inline
In-Reply-To: <1409993977-4383-1-git-send-email-osandov@osandov.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Matthias Beyer <mail@beyermatthias.de>

On 06-09-2014 01:59:37, Omar Sandoval wrote:
> Fix checkpatch.pl "Alignment should match open parenthesis".
>=20
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  drivers/staging/bcm/sort.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/bcm/sort.c b/drivers/staging/bcm/sort.c
> index d518c42..ca0b179 100644
> --- a/drivers/staging/bcm/sort.c
> +++ b/drivers/staging/bcm/sort.c
> @@ -28,7 +28,7 @@ VOID SortPackInfo(struct bcm_mini_adapter *Adapter)
>  			DBG_LVL_ALL, "<=3D=3D=3D=3D=3D=3D=3D");
> =20
>  	sort(Adapter->PackInfo, NO_OF_QUEUES, sizeof(struct bcm_packet_info),
> -		compare_packet_info, NULL);
> +	     compare_packet_info, NULL);
>  }
> =20
>  static int compare_classifiers(void const *a, void const *b)
> @@ -48,5 +48,5 @@ VOID SortClassifiers(struct bcm_mini_adapter *Adapter)
>  			DBG_LVL_ALL, "<=3D=3D=3D=3D=3D=3D=3D");
> =20
>  	sort(Adapter->astClassifierTable, MAX_CLASSIFIERS,
> -		sizeof(struct bcm_classifier_rule), compare_classifiers, NULL);
> +	     sizeof(struct bcm_classifier_rule), compare_classifiers, NULL);
>  }
> --=20
> 2.1.0
>=20
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUCxleAAoJEJi+S08gyg+UnRsP/1dGIgFtk25rcotfjyhHnil8
kdIfLI+a9ht5dLXAajD5eigRDrlT5aTh2NSh+fTM96rABkjvWu2Sc3SLJSX7ovOL
j1oR65IEQTk/4uuGBQgR7R8u7e8V7TJ5trY79sDh3FYUdETvFuwjb3tKMrSrPW6r
XSUDe50QBQ2cXojkcSX8hy/TnxgrMCg0I1CtojAOYfgyaCvU2Rqv9Auad2E5VmC3
VY+1s6oJ4VO9oiaTZ5noAugQw4qtdzbmaf2qqwgFq9mBMGbBPAevK25v6NOr9me3
dc92BVWdO33M/lqflhaE/3MptcDiY538ZnrxX4RgUmFG1giNYYOjWCGuP4vZ3X4X
Lw+a/FVwQZh9cuulKkVxJvrKZChZlkGUoyNGZp4TEc9uSFd/6qIFwS3SWY9P2eXM
3MaZMcJszrfxXvv5aFP+qjoxmGTyC7uJyIhZxt7wrXujtKY33WnOYrvCy+0ldw5X
sYkd/AIIT1sMuQ5Z6iBE21a+9wgdk+BTGw+WeP0HvPsZDJ1dwKLfHFq5Wv7SLZvb
ItzjuR67a++67yWU2oWqZDdItZAumjNgiOQN1EpyJVw1nBVLPoQJJZk/yWjnj53q
smtnrTaJ54fNeftn1HMQKruU/WjwMCDLAC/i1MLdao/n5BnFHWyogw9vMNmExML9
s1wcw8LOLCzeYw6Dijyn
=nsmd
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
