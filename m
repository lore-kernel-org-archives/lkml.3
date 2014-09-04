Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaIDTZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:25:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43891 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbaIDTZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:25:50 -0400
Date: Thu, 4 Sep 2014 14:25:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20140904192535.GJ13421@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140904184021.GA13421@saruman.home>
 <20140904191642.GJ5001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fU0UwhtRbpo05rnG"
Content-Disposition: inline
In-Reply-To: <20140904191642.GJ5001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fU0UwhtRbpo05rnG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2014 at 12:16:42PM -0700, Paul E. McKenney wrote:
> On Thu, Sep 04, 2014 at 01:40:21PM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > I keep triggering the following Oops with -rc3 when writing to the mass
> > storage gadget driver:
>=20
> v3.17-rc3, correct?

yup, as in subject ;-)

> I take it that the test passes on some earlier version?

about to test v3.14.17.

--=20
balbi

--fU0UwhtRbpo05rnG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCLyvAAoJEIaOsuA1yqREH1UP/jJSQYqcq7k7iYdmSJldXxCd
JDTYwrZoxjhd9rGZ1E3Joc0C1Or7IZkdClnIU0+3V6DVJpzrESlTfD0qcfJ//qJ+
qXSxtqiEzPWZf5B+xbLy5ECpQU8y9cnsExzBecJ13NS5FcxeN2frFD2O18ECTtyR
aFaGKjp0FMy0bdkWVppjA5i8Xn95CFvfuz3iRxQ5f3Un68kJrFUHe/UVFJb1hCfR
PTwhPn97NAfbc4iQh3RK6UcHkF22i0YASdpA1YBSq2vvcuLIEZM5pxqH+RCjhCGQ
Awn414KJnLAlHzlkbT8u7AlJkYGzAzosCEcB6v9HN/c4YCReENKuuyodZa+sbV+z
WueNXmjxjxMN7pgrbRtOnwU7fHkiys+V6qjKionYBnkPM3M4B/zYaBzPsex6iXBi
7YE5wevnW7xHE4cMRNEngQaBEMZl7xmzIS/Ydq9s5rI9LWwu9+7slV1CDCAS97f0
I7vXPhr0s9ignRAaYB3jh2qhi0hknL6QHCAqj7OMlHEXsTloZxf/1o5dNqRevvkZ
wsUAc3lDCi2CgHbdXHLh/b5rq4eG0QhYHwrEJG5E4fesKG1nUwhHIUxpBnbiPqfJ
CDhIwFOA6RFGPFOuN0ZmBBLFGBjb4b9W6qk+N3VIdiK02J4nszFh60oOpBZGjYA4
TmSpwOCFYqX+ztgvBKma
=tj46
-----END PGP SIGNATURE-----

--fU0UwhtRbpo05rnG--
