Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3CLSnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:43:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48327 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab3CLSnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:43:23 -0400
Date: Tue, 12 Mar 2013 18:43:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: core: fix possible memory leak in
 snd_soc_bytes_put()
Message-ID: <20130312184319.GM19942@opensource.wolfsonmicro.com>
References: <CAPgLHd_DuPDciAt9Qdn-1K2CSL14GDKt6XR+8gaac8hgvLScaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z/kiM2A+9acXa48/"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_DuPDciAt9Qdn-1K2CSL14GDKt6XR+8gaac8hgvLScaw@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z/kiM2A+9acXa48/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2013 at 12:35:14AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> 'data' is malloced in snd_soc_bytes_put() and should be freed
> before leaving from the error handling cases, otherwise it will cause
> memory leak.

Applied, thanks.

--Z/kiM2A+9acXa48/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3dAAAoJELSic+t+oim9NxoQAJLV5Is+wD+32jmk8xDatbVs
kAcoltspELFNTGAxYNeWw+ZqQp/GsTvC4sHy5rqt1zxc9X5iQBkK933KvJ//yrdD
ozu49KGvtn+0rVJKv0nwVCEG+pZhkodUAK8XWnKBtXoeFWCmMjcjLOEmMiUBuRPF
7IFLS70IRBkA1xRWyaKsQFr3hLCarbCFyYEkm+Td6Wmzr/1uk14JmJ/dLkh5AQ+k
3AWGeGJajPcbVSfDSxZsIiIGm1sGTUOGAtiB27NbWSWqcOvbLFKkXglI0bsDnMF4
/AclfcFXI9N6Kng5L8CZIcq+qX61UtWHfJ3aMwgtd8PzhVdqt2ePYMIw873fnCha
V6Pim7UbPP8BQQ05GVIwYA2JJZcPgsw6JnkVEWQSyfToDjgtSEKIPC5Hb+nLYP9M
57zjoxK0QEj1GYA/bkmYvYppqxeG38qG6b0YA8lLDsTt3/7oc/O1ZvOwpDygFGyH
ikrkA4ZxL2bjhJcuDtyB3/8M/e4ay2D1ib6LvB4RJcd1xAG81beffJI/Bzs6Y1i1
vV2MBvxDpcJlTg69yXiPT3DWRsTSO8oF+bKacsCRlIm0der8p0O7HGQYdiTwBcXt
NE8wVUKdzeqZERP6+rnIjbOjMTTUzNWOOsBgIKYcEqmCb+uviDsOTtu628f9bI9n
FPubaI1p5DhpgRKezSLr
=kycF
-----END PGP SIGNATURE-----

--Z/kiM2A+9acXa48/--
