Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaKLLYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:24:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:23382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaKLLYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:24:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="415336481"
Date: Wed, 12 Nov 2014 16:55:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v4 00/58] dmaengine: Implement generic slave
 capabilities retrieval
Message-ID: <20141112112529.GK24582@intel.com>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141106143349.GL2989@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20141106143349.GL2989@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 03:33:49PM +0100, Maxime Ripard wrote:
> Hi Vinod,
>=20
> On Tue, Oct 28, 2014 at 10:25:15PM +0100, Maxime Ripard wrote:
> > Hi,
> >=20
> > As we discussed a couple of weeks ago, this is the third attempt at
> > creating a generic behaviour for slave capabilities retrieval so that
> > generic layers using dmaengine can actually rely on that.
> >=20
> > That has been done mostly through two steps: by moving out the
> > sub-commands of the device_control callback, so that the dmaengine
> > core can then infer from that wether a sub-command is implemented, and
> > then by moving the slave properties, such as the supported buswidth,
> > to the structure dma_device itself.
> >=20
> > Comments are as usual appreciated!
>=20
> How can we move forward on this?
>=20
> I didn't have any comments on this version, and gathered quite a lot
> of Acked-by already.
>=20
> Do you want me to rebase on top of your current next branch and send
> you a pull request?

Hi Maxime,

Thanks for the huge cleanup work

I quickly looked thru the series and looks okay. I will do a detailed review
in next couple of days and then host it on a topic branch so that Feng's
robot can test it before merging it.

Thanks

--=20
~Vinod

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJUY0OpAAoJEHwUBw8lI4NHp84P/RmTcm0zR9v7VQHIa0Ui6Sws
QnnIqqCGflEvEyWcW0ldaLABRNtA/kNI0q8nqWVB8nb4IMtmkFkUa5P+6i0bk+96
Me633n5hRdbB09S+17I1kqwjn/7tB9sWfdHhfNyJiscuZl2FxYOX/tWzgX80sN5P
dyY1q/pHAjcsLl9f4+iX9ZakFA1f+VwYPdh5j3JoyC0/3Odi7MgL9iZaMe+l+NcQ
ypk6xpu7LmvoTnNwyrf8CDPw4RLWkeH1nSRcXQ5i5cTEIIBgfKUwSduXWQierVa4
vYXazSdBqOYhO40yoDekVZ9ZAAb8AajhmetN4q7EWQW5JYDc1j3AonbKLiDRnN31
XC0I6t+ipg02WIlKvEMjXuxOPUmwps43p2aD0cheGWqkt1Y10c2P3NbCZ2Vo1Puj
tf6r1cj+PJrUVAUEseEcMGEnC27ilBfszOtRXBhnkgEPKQmJE2ofPiWGqA8HQVP7
SfpyxXzJhEQQBvBNEbPWdY+A40FRcn7C4F4PGtUrWJTjKafwaD4XEOfFrWPH3uI/
Ik7WuWSLJiGuHXouNhRkEkNuQBlqV8BEHIEjAtYdgWzsuA4/uEND/9uLZsLf5n3I
NgSYLcvlu882yfraZgqo7MXXD3IBTyehmeeXH37wjI3zG1jbIGLcBosI++ZNbMyq
G4jo4f6A05YG1g9N1dRc
=NMdE
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
