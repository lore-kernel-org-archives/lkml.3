Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaKEPBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:01:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41184 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbaKEPBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:01:45 -0500
Date: Wed, 5 Nov 2014 09:02:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Tony Li <tony.li@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: remove warning of disable scramble check
Message-ID: <20141105150211.GA6548@saruman>
Reply-To: <balbi@ti.com>
References: <1415093391-4569-1-git-send-email-ray.huang@amd.com>
 <20141104144726.GD24983@saruman>
 <20141105043951.GA9906@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20141105043951.GA9906@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 12:39:51PM +0800, Huang Rui wrote:
> On Tue, Nov 04, 2014 at 08:47:26AM -0600, Felipe Balbi wrote:
> > On Tue, Nov 04, 2014 at 05:29:51PM +0800, Huang Rui wrote:
> > > Some SoC's FPGA platform will need this quirk, but it will complain if
> > > running at true SoC platform. This is a normal case, so remove this
> > > warning.
> >=20
> > nope, why do you need disable_scramble on actual SoC ? Without an
> > erratum number I will not accept this, sorry.
> >=20
>=20
> Oh, that's my faulty. I can set disable_scramble_quirk=3Dfalse after
> actual SoC, at that time, we can drop FPGA support. :)

correct, thank you

--=20
balbi

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWjvzAAoJEIaOsuA1yqREaZcP/2u1J2UWNp2DKQ8GRhiurlUi
eA29yftg6tifX4o8xHSc6GHU9EOT64w4yYlzuOx0OA3u9F5XoP8cHPZG76Y6ub/6
NS4D4CzKeVMiGEQ3xTVtGezbeTMYAellqhH0MEy84SuWkKPaRmbKXEhTLd2ma+YM
3uJxjHBLNjvjE2u129hnQJCBbpedLga1Asvla7Yn41dwIXdgaZwsdz9zTJ92TfQV
+J0eGEldD/fKG+RJB0ytZ2OMUaidgGuFuwKalsn8VHx4ayHoh0h2iAUz8kQWu6pT
Xl1u92qITvPFk/7W6lPq0cEh1JLl3UTaWqkbT32uI1/24m8R9AuqmHc5IAtURTE3
1uoQcfBvOxUmEM56ap1+Rx5Ano+wSvv9TYxGaELgcOOIUnGA/wEemtwj6frVfTaJ
zt6uN4GEXESfSK3Lbat5PaXzQJ0+gwEUXs3NhBlLaUNcIklFN/THuugqA1BKoBlT
/PKCjQaBO1ugpz5lxTOjXdWXkcav6W+1YZefwSubnmzYbEI6/bE6RSGd1Qb+GNhd
gcIOCKQicgHFYa55NRDMPxIlGWxyVshnt/5h7n1uor6nQLVBVLvdnBDHQAt8M0bV
uEKysxByzaporyzT4rewUdY94PZ4cgKqgExwkBTz3miEsvGK1GqDqoAWsjK2R+yn
IvVIEp/BujG5VldjyuDU
=BtAC
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
