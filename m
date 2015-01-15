Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbbAOPb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:31:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:13940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbbAOPb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:31:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,404,1418112000"; 
   d="asc'?scan'208";a="651617253"
Message-ID: <1421335864.2632.29.camel@jtkirshe-mobl>
Subject: Re: [PATCH] e100: Don't enable WoL by default on Toshiba devices
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: David Miller <davem@davemloft.net>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2015 07:31:04 -0800
In-Reply-To: <201501151618.07434.linux@rainbow-software.org>
References: <1415832445-9524-1-git-send-email-linux@rainbow-software.org>
	 <201501151440.32159.linux@rainbow-software.org>
	 <1421333621.2632.19.camel@jtkirshe-mobl>
	 <201501151618.07434.linux@rainbow-software.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YTqdUk04Tyw980ja0TNA"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YTqdUk04Tyw980ja0TNA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-15 at 16:18 +0100, Ondrej Zary wrote:
> On Thursday 15 January 2015, Jeff Kirsher wrote:
> > On Thu, 2015-01-15 at 14:40 +0100, Ondrej Zary wrote:
> > > On Thursday 13 November 2014, Jeff Kirsher wrote:
> > > > On Wed, 2014-11-12 at 18:18 -0500, David Miller wrote:
> > > > > From: Ondrej Zary <linux@rainbow-software.org>
> > > > > Date: Wed, 12 Nov 2014 23:47:25 +0100
> > > > >
> > > > > > Enabling WoL on some Toshiba laptops (such as Portege R100)
> > >
> > > causes
> > >
> > > > > > battery drain after shutdown (WoL is active even on battery).
> > >
> > > These
> > >
> > > > > > laptops have the WoL bit set in EEPROM ID, causing e100 driver
> > >
> > > to
> > >
> > > > > > enable WoL by default.
> > > > > >
> > > > > > Check subsystem vendor ID and if it's Toshiba, don't enable WoL
> > >
> > > by
> > >
> > > > > > default from EEPROM settings.
> > > > > >
> > > > > > Fixes
> > >
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784
> > >
> > > > > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > > >
> > > > > Jeff, are you gonna pick this up?
> > > >
> > > > Yes, sorry I did not catch it earlier.
> > >
> > > What happened to this patch? I don't see it in net.git or
> > > net-next.git
> > > (checked both davem's and jkirsher's)
> >
> > Sorry, I thought I had replied with a NAK on this patch after further
> > review of the changes.
> >
> > We don't fix BIOS issues in the driver especially regarding feature
> > enablement like WoL.  We would end up with dozens of these kinds of fix=
es
> > if we to allow this.
> >
> > You should go back to the OEM and ask for a BIOS update to resolve this=
 or
> > configure udev so that ethtool disables WoL.
>=20
> This is not a BIOS bug. When the machine is powered off in BIOS (or GRUB)=
,=20
> everything is OK.
>=20
> The bug is that e100 driver enables WoL based on some bit in EEPROM that=
=20
> happens to be set on at least some Toshiba laptops and user has no way to=
=20
> change it.

Yes, the EEPROM can be modified/updated through the BIOS update I
suggested earlier.  So again, a BIOS issue.

OR you can configure udev so that ethtool disables WoL if you do not
want to pursue a EEPROM update through a BIOS update.

>  Windows driver does not do this. Other Linux ethernet drivers=20
> don't do this. When user wants WoL, (s)he enables it in BIOS and OS. Mayb=
e=20
> this (mis)feature should be removed from the driver.
>=20



--=-YTqdUk04Tyw980ja0TNA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUt904AAoJEOVv75VaS+3O5L0QAJrV0BHt9wVaNqRs977120v7
1Jgt2uVGWuTIRVxZ/yOkbZ30+5kCr2ncXyKPzEecPDHpaGIBLdFURSvODK1rsq9O
Z1tyZvSN29E+7C1xq8PRZ/qVYgvAq9BYwrwEDugtOsD0M+WFNQ9dDOdzUatriyqb
iHNCkmRJq1eqcKZvORAewACRDTfDskHOJD8XMTOGYLumWio5hAP8OTSbJOB6t9rl
ToPw/nB9Fp0BHydfCvl+NcciU1dOIBj2gg1pBEcYbKR0ynUPJYX5u2Ehicpk9LGB
UgWHF39ZCEJ74fpyxl9wml8vhuYz7NGPn/Tu+WD6qF2e6ZSW+J6OYA4xnFhkQnZj
+Qd7wS2z7w3eoK6x05c2knb9wH2GwHTPnpaALXJ6hmniNEmwO4GJne5tZGTTHIRb
7zZuBUo1OKsZj6Oe4OYty9P/Dq3uq9KEwGurdJpFIyPB7LVss/5jh0WDV00m9b7x
KDZ66zbsmx1KpggsFWDzxy8jdeP8ovFnZ5FM0mK58/xcLOF9Y3UV/gYNB+tfACiK
attxyc7kKrx4JIlvK0T0bHl1s8/Z8UBLk/yyjMunm811k6BjNqhPq9vZWlYaiVJI
RLclSrfsOl8xknvhctu1Thia4pbPJj2WWlDZ9O1S0Ial1JYsKipGz7WQKgnQ+dqi
XYqBwqN5Mnr1LplzunT1
=jOqL
-----END PGP SIGNATURE-----

--=-YTqdUk04Tyw980ja0TNA--

