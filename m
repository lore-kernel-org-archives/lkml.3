Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904Ab3DHGTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:19:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13982 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934751Ab3DHGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:18:59 -0400
X-AuditID: cbfee68e-b7f946d000001e37-4e-5162614609ab
Message-id: <1365401875.4353.44.camel@kjgkr>
Subject: Re: [PATCH] F2FS: Fix the logic of IS_DNODE()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 15:17:55 +0900
In-reply-to: <1365353824-11745-1-git-send-email-zzhsuny@gmail.com>
References: <1365353824-11745-1-git-send-email-zzhsuny@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-8Goebqn4pOazKR/Nj2g7"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zQ123xKRAg/Y77BaXFrlbXN41h83i
	96I5zA7MHjtn3WX32L3gM5PH501yAcxRXDYpqTmZZalF+nYJXBk3bi1iLmjhr5g+/RxrA2Mn
	bxcjJ4eEgInE/82T2SFsMYkL99azdTFycQgJLGOU+DVjJSNM0elnl5ghEosYJVqX3mSFcF4z
	Svw71skEUsUroCOx5fhPoHYODmEBM4nW5WYgJpuAtsTm/QYgFUICihJv999lBbFFBFQk7m6a
	CzafWcBDorHjO1icRUBV4sKiQ2BxTgEniXv7pjBD9DpKnLz3B2wTv4CoxMnWT1C9VRI7Fs5m
	hrhTSWJ3eyc7xDWCEj8m32MBOVNC4CO7xMylv9ghFghIfJt8iAXkNgkBWYlNB6B6JSUOrrjB
	MoFRfBaSsbOQjIKIa0q0bv/NDmFrSyxb+JoZwraVWLfuPVSNjcSmqwsYIWx5ie1v5zAvYGRf
	xSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESr307GG8esD7EWAV04kRmKdHkfGC855XEGxqb
	GVmYmpgaG5lbmlFFWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY0bY+1QmzYPr
	J4cd1hOb1+c/NYN/xmVHmWeurgfZbtW5G+4Vt5S+dTrFr/2/8aqjq4+X36tyZj62wMeq4MgF
	Q7Yvm813Znd8OhHAeMVd12Jp/qp6jtoFU7P5ZiafnsV8rSl7wQOPivdHe7UyPZluzRG82sFe
	b/A74LOn1XTtS/v1NSVkeS/6KbEUZyQaajEXFScCAL3nnmkEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsVy+t9jAV23xKRAg1lXmCwuLXK3uLxrDpvF
	70VzmB2YPXbOusvusXvBZyaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4AWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEy
	QAMJ6xgzbtxaxFzQwl8xffo51gbGTt4uRk4OCQETidPPLjFD2GISF+6tZ+ti5OIQEljEKNG6
	9CYrhPOaUeLfsU4mkCpeAR2JLcd/AlVxcAgLmEm0LjcDMdkEtCU27zcAqRASUJR4u/8uK4gt
	IqAicXfTXEYQm1nAQ6Kx4ztYnEVAVeLCokNgcU4BJ4l7+6YwQ/Q6Spy89wdsE7+AqMTJ1k9Q
	vVUSOxbOhrpTSWJ3eyc7xDWCEj8m32OZwCg4C0nZLCQpiLimROv23+wQtrbEsoWvmSFsW4l1
	695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwcngmfQO
	xlUNFocYBTgYlXh4D3xNDBRiTSwrrsw9xKgCNOfRhtUXGKVY8vLzUpVEeAOVkwKFeFMSK6tS
	i/Lji0pzUosPMU5kBAbHRGYp0eR8YArLK4k3NDYxM7I0MrMwMjE3p6WwkjjvwVbrQCGB9MSS
	1OzU1ILUIpijmDg4pRoYQ2v9Jvx3Zvb49+SNY2h+27ZC9SzrM1xtt74/Xmd67fC3kG/7MyOb
	shXTT7JaeJm671lQVGB59c+3axdka718ft0/wH39qfZj5oXJC9Zuu5V5uXSz84WlGxqa+g/O
	3fuqMsetuGFh4LFZznrfOwNMVY0NrpYxBbzVstm+pnJDYGn6WcmHP++ZKbEUZyQaajEXFScC
	AC8yGpaFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8Goebqn4pOazKR/Nj2g7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-04-07 (=EC=9D=BC), 12:57 -0400, Zhihui Zhang:
> Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
> ---
>  fs/f2fs/node.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index afdb130..2be47b2 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -239,7 +239,7 @@ static inline bool IS_DNODE(struct page *node_page)
>  		return false;
>  	if (ofs >=3D 6 + 2 * NIDS_PER_BLOCK) {
>  		ofs -=3D 6 + 2 * NIDS_PER_BLOCK;
> -		if ((long int)ofs % (NIDS_PER_BLOCK + 1))
> +		if (!((long int)ofs % (NIDS_PER_BLOCK + 1)))

Great catch!
I'll apply this.
Thank you.

>  			return false;
>  	}
>  	return true;

--=20
Jaegeuk Kim
Samsung


--=-8Goebqn4pOazKR/Nj2g7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRYmETAAoJEEAUqH6CSFDSPRUQAISWMQTzErfk9ME1y//A0hAH
Kyx9Mbyu8xxXOQNiwHUra25DkOxvS1y0EUQIQLvYzuG5u78gmjaq3P6tRHEGs/G6
+pgXV5GRt1qWba9m02F5H4Qghu3i8ofUTzg5chz+rPBSGo4mVJUqDDgqTr7crMgJ
ie9B+y+9GUYmsBXL6pHb9PNKrjmBE7XE2dBKN8804ywU8wFz2aIMBcBUXzQSKgM+
2D4gNsrH6nJ2fFrJpFEN2csX03gxT2T4/IQlz938moMP9qpJ63JJHVSgg8f/y2DS
Iwo/R5XIn+7Q208tDtg5PleUZi0aLSVqBc4q7JM1hbxvLuOgq++WkgfdW1wJjHdW
l6aCl6rpjtE94o0hWKziQUA7MOEwiZNPyas3WJ5AcjQccoUVTm/Lnc7qWLQchGLv
9PMjif14EeJ7Ujk3S2SBRJDYBKYwmzPvCqYN3e+U+fzzK4GuMYBgtx61/e6AHuoM
ArzbMLFbHhAltfJvlZPbBGMSGw3nX0luHWa1UMTgwQfhVcEyQUZvq6RIstN7ADMy
qY4hAouXhW1h26qSUAlhU0OsTa6BAeyfT9zjBq8jpMfYj8lLfBXKjpUIx8h6n6tu
2Kg92Q5+gToI6qgFXnrOVHaerhot3ymMRqIE9noaNVQymLDQ+tpZeKXLxSZ3NNzu
eOFPLBD2xeOghFBgbkHD
=kBZ4
-----END PGP SIGNATURE-----

--=-8Goebqn4pOazKR/Nj2g7--

