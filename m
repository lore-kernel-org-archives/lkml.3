Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaIHNqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:46:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48180 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaIHNqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:46:12 -0400
Date: Mon, 8 Sep 2014 08:44:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Message-ID: <20140908134454.GK22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
 <1409656338-20337-5-git-send-email-gautam.vivek@samsung.com>
 <20140902143438.GB16872@saruman.home>
 <CAFp+6iEyqmbwMLFrBKD7NVLDAC=b+h1hPKFS=BG4k9D69hn_dg@mail.gmail.com>
 <20140903144225.GD31855@saruman.home>
 <CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
 <20140905175651.GK24449@saruman.home>
 <CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tBhgiDt8dP1efIIJ"
Content-Disposition: inline
In-Reply-To: <CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tBhgiDt8dP1efIIJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 08, 2014 at 09:53:09AM +0530, Vivek Gautam wrote:
> On Fri, Sep 5, 2014 at 11:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Sep 04, 2014 at 12:01:19PM +0530, Vivek Gautam wrote:
> >> > Don't we have phy_power_on()
> >> > for that ? It looks like you could just as well do this from
> >> > phy_power_on() ?
> >>
> >> No, unfortunately keeping these calibration settings in phy_power_on()
> >> doesn't help, since we need to do this after XHCI reset has happened.
> >
> > teach xHCI about PHYs ?
>=20
> sorry i couldn't understand you here.
> Aren't we trying to do the same with Heikki's patch about dwc3 :
> [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
>=20
> and the 2nd patch in this series :
> [PATCH v6 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
>=20
> Is there something else that is expected ?

right, use that to call phy_init() at the right time, then you need to
add a new ->calibrate() method which, likely, will only be used by you
;-)

--=20
balbi

--tBhgiDt8dP1efIIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDbLWAAoJEIaOsuA1yqRE8c8P/1ZtYbUpQZ4fWetW61TQPWu4
MYK6RzBzeCwaJQNjELvEZpdDVZJY0tIrm9YqYs2pDtujMLi3Y8F7gR2YBKR9qXhd
60pBMljyhYzh7j23kuzTzW7z9WpKMAKvQntlXz9mbpw5OnUXV07WQJQYPbiarxDC
96N3OVwmX70qzAbkFdJSD/VVh13xzplhX7YYnubpliU82X+h5JewpmXNvjBf8lyS
vSLV/gLDwCrCgg7m9ZfvuPUDjvz4uY6z4c7t8pfHE1Ol/Sj34lovN4l8FR8qnSkU
BTkt8q/gO1BrjbOGIksf2tU+mv7LNnJTk0VUfCIS2zZAq9OEy1senGk6dniAT/tS
6yzYhghnVn8S+X0AL+6OXIvqjRT2Qonvf2TIdHW+8Laye6cdtS1MdsCWv4mjJqlz
UJXhRV1RufFCAlBnk/y41YIei9qBfWubxJD1YHW/otdSDaETB3oSwzLrfh4iPJ2m
wySbDrNIl19V2asJ7Ii/ATILYzfhQ1tyMdsJaLgLo6V79XrkSeCxceCJRdsuEFNM
iAcyAs25GICVZmVuECWnGEG8aMiYH3dYJIn3qB87DUT7flV+tI9ba+bl5gMVNs06
rvlaB5nQoPbTbp4RmOUq9t/vJPPRNBD5L7ee0YM2ZTIc0nJe31YnAzarCwgT754A
pBdrbtUiD5Fb7HjoHdkq
=GOVy
-----END PGP SIGNATURE-----

--tBhgiDt8dP1efIIJ--
