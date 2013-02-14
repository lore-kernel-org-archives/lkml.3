Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3BNGwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:52:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab3BNGwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:52:46 -0500
Date: Thu, 14 Feb 2013 07:52:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] of/pci: Add of_pci_get_devfn() function
Message-ID: <20130214065239.GB29588@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-3-git-send-email-thierry.reding@avionic-design.de>
 <20130213225950.155F93E3557@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <20130213225950.155F93E3557@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WXTAuVhUKNP+jXSCNkO5Sdu4L72j7Cl90Sz5T0NaQwK
 NauZxjBKfWHdQua9d++PbV93mcCWiC+6b2bxHZcgDEDvJK4pS6
 YLEnISI6mbkvNMKaCHuNxrfbT+xy6HNwOIRshg0VilwwtH+e7s
 a4KJBOarVTSOyFRS9F9hCcRQTq1/xFSCJjO0R8iBolXYNNkDyE
 SMMLJhf80+iWQCsoW3eHrReYh7EJZArtUvNskAYSgen4eyFmUp
 UAFJmLQ+LdP6pc1dsvFDUZL6LF8xJwC3WnPKzGp/1z7HmB6UWr
 +ySzNUz01MgPvxiljM6E/S36DX8kBydofjc31Aja9uBAYHAOOS
 3EMdWvtgul5KjVguIvP7KU5GtJzvuq4TlYA/wSHsHQqafFSvx1
 ja9cknOTcQCCDR1MIH9avgM++/5Xf6PCWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 13, 2013 at 10:59:50PM +0000, Grant Likely wrote:
> On Mon, 11 Feb 2013 09:22:18 +0100, Thierry Reding <thierry.reding@avioni=
c-design.de> wrote:
> > This function can be used to parse the device and function number from a
> > standard 5-cell PCI resource. PCI_SLOT() and PCI_FUNC() can be used on
> > the returned value obtain the device and function numbers respectively.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> > Changes in v2:
> > - rename devfn and err variables for clarity
> >=20
> >  drivers/of/of_pci.c    | 34 +++++++++++++++++++++++++++++-----
> >  include/linux/of_pci.h |  1 +
>=20
> There isn't a whole lot of value in this patch without another user.
> I'll need to see the other patches that make use of this.

Alright, I'll take that back into the Tegra series as well.

Thierry

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHIm3AAoJEN0jrNd/PrOhjzwP/2Uyr/RD6NE+/RlunBwZocqX
jHUTWB8DT5QZluhvnzJZK5xgS1fIAGN/yzrH2GXYCBXyJshXmlK6YoEqqPMK0EL7
Y7AMZlyNnVjGU73unoMmkUzkTnXKd5WsVrmaG/Z/7jQOC29BSBcR1QvfV0wasaon
aLJpRFnMCs0yX7fhDtZi5KlFdjvTShyiydDwUHmiIOmA5/fdP0Azdw6vjobHCflq
W7btqAWyY6P+oiKeWyyYhIG/5dgVWxeUWClgWu1frzvd42+X6/BUl/P/PCAWha3G
JOhb/5u6imnOrulacp6CMrzJYGlpF7XNqQrhTBjlTMyPgpvaKXIFVLu/tzrJyF4J
0aT1EC0goIf0Clow1/ziD/cxQQBbMSQ0KK1El90T86+fEEh2VxnXRM9kTUto3uJD
BNttcjfgeN28gWuN8n7ZLl8t3i74fP34MIyXAkk46gWe/fXw2AaUIViMrSBg3Yz6
660+pWX1/chkzOE67GmoxGIg9w+x0AY6V/8C6nX+coGJk922SrLA7dNq0BEShoC0
il1oW9cI3v+YT2YNm8+WclJLnvFBcJthOJB9ghyaZu+BMrxgn8pwt9x6GfjNYnB0
132Yc5CT4ZbkX53GhtcHkoSuMt9jMD3L0/y7RhDt4S4LY0EJUiXFFaydu1AjiOuI
a9L2OCqMT0NhzVJdcmbM
=ZMP8
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
