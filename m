Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaHUVt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:49:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54416 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbaHUVt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:49:26 -0400
Date: Thu, 21 Aug 2014 16:48:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Frans Klaver <frans.klaver@xsens.com>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Frans Klaver <fransklaver@gmail.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/4] tty: omap-serial: use threaded interrupt handler
Message-ID: <20140821214840.GU11146@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-4-git-send-email-frans.klaver@xsens.com>
 <20140819185701.GC22003@saruman.home>
 <20140820064028.GC9319@ci00147.xsens-tech.local>
 <20140820160604.GH24500@saruman.home>
 <20140821214117.GA7076@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OFtM20PmL5gDcvsL"
Content-Disposition: inline
In-Reply-To: <20140821214117.GA7076@ci00147.xsens-tech.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OFtM20PmL5gDcvsL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 21, 2014 at 11:41:17PM +0200, Frans Klaver wrote:
> On Wed, Aug 20, 2014 at 11:06:05AM -0500, Felipe Balbi wrote:
> > On Wed, Aug 20, 2014 at 08:40:28AM +0200, Frans Klaver wrote:
> > > On Tue, Aug 19, 2014 at 01:57:02PM -0500, Felipe Balbi wrote:
> > > > On Tue, Aug 19, 2014 at 02:14:47PM +0200, Frans Klaver wrote:
> > > > > At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 16=
00 uart
> > > > > rx buffer overflows within 30 seconds. Threading the interrupt ha=
ndling reduces
> > > > > this to about 170 overflows in 10 minutes.
> > > >=20
> > > > Can you try Sebastian Siewior's patches for 8250_omap and 8250 dma
> > > > support ? That should help you a lot.
> > >=20
> > > I'll have a look at that series. Thanks for pointing it out.
>=20
> I have had a look at Sebastian's series, but I'm not convinced
> yet that we should use it. So far the serial console seems to be
> missing data every now and then. I haven't gotten around to testing our
> high traffic application yet.

as any new driver, there are bugs to be fixed. How about reporting the
ones you found together with a way of reproducing them so they can be
fixed ?

cheers

--=20
balbi

--OFtM20PmL5gDcvsL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9mk4AAoJEIaOsuA1yqREHVMP/1Da6QLV+OxT2cDkntSGLpWl
+bK8eDxazQMJMru7oH67z1Rc2ABUymwQkAuv5ohi8Qsi5svBQaiF4HsGmlxR39UN
C/zp6T5KkVCL1kJPbRVrw7maHJN71Ugm7MRUJF23cgklXjLhcvkmIje8f4oCbYCA
07MQvEEEf8zcqiRXz+6grBi4CVQONxBDcy+61srDNbXqkDekoRmT3ihfFujqw8hM
DXlvBb+FI4f2IxwLN5h29PPrwuino1A623PRtbqiDu2nIwEaLwjFw9N60h2+cI22
lgJZXSIAouxy6M99vbOHNJTfvs6bJ+B8tlN/GFwVRUxxzb+8vK5DJ+nIkFnXA3mu
mz6CETc8YArlxrTmvXTEx4P67kunGCXtO34FfLJ3H57yKpb4LMo+cHouN12W1RkY
U6Bim8ByUwqReN+W5kuZfrRyn24V6lHdq9YNXh564bpIdzZhtm1bSU/9eVNzK5p6
iMBW9xrA/QYJ0f9AUOu3Pw7XoHIC2PLUb0PIhOtw8B+RIydbDUtdrpgSAPSUNtVO
WH9PjlaBh1kL3JUV0ZNTjFvmHLKNqOCXZrCplZtCXs2K9QuGyONwRmdXxojcSuG7
i2i8zxd8/g2uuN4/Wfq6T6gXeS/vJAED8/A8SO3uBnmHoTOtZHblG56D/d5Q2apX
yOmbT0Vzb5CkLxCtSX2S
=XFUR
-----END PGP SIGNATURE-----

--OFtM20PmL5gDcvsL--
