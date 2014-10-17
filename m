Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaJQPAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:00:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37704 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaJQPAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:00:33 -0400
Date: Fri, 17 Oct 2014 10:00:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/16] usb: dwc3: add AMD NL support
Message-ID: <20141017150017.GM26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-2-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HVCoas+krw6dou6l"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-2-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HVCoas+krw6dou6l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Fri, Oct 17, 2014 at 04:53:26PM +0800, Huang Rui wrote:
> Add PCI device ID of AMD NL SoC.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>

this should be the last patch in the series, with all quirk flags
already in place. This avoids bisection points where AMD's platform
won't work.

--=20
balbi

--HVCoas+krw6dou6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS8BAAoJEIaOsuA1yqREeRUP/REBtcwPI/3xmU/fDFazn3Xd
MbQV26nTLf1egBe/d0YmsU64+DOiZiFyXaL0uKrKHh7QC4PdQbk5COFDYxJlEeY9
eKxSjZKiM8NDUmhQOTdYa7X9QBucQvP8psY225Rglpx++L4vadbFgkcO15Tf2XDW
/mAbh+gQvBgpnRCvhBrEsXadgaiRqxEwYsnuydabzx4TPDlGiOdTeJEE9wfZZyPL
10BUvcRwFo9/cPYEqnpCDrf1V19HCfPLnz8Y2lBzhCMWAM0w+NIAA/mHeofdVlr0
0a6S+EcBlZiI55ns6qVSpRj3s4f66Be28RodEBq6Oy8IazqU4yWKtsxDATufzO3y
gU55HW5XQUSP6mqOGCmqCWowpHw8De6a0dX+LB5zhMMgJ99obBxcERPNx6lCVBBS
JrKE9esd9DsIcKdRQwBpNbOV6B9zzO3/VCjWfgdJn0jEts4YG7i9m8X3nVhNxFyF
LOuH716xdJIHaI/K6SiGjUCtE/Ek8oal5cW/u/te8xUAA0Ex3ElAsMKXCCCSlTGs
C5vWCu8B0KZnT/T7q2o4QpukWoLwlhHWncCrAPZ0YLOPj3t9gSa/5e5vYGYrxmxi
N1Mx8O7pStC+uV6C/DgC3bSZl9yqbmUo+egTBGAt5EdGUVJEhRDfk7JXFKy8+mMu
6IexQkWHGKEUoFb3hF4b
=nDJZ
-----END PGP SIGNATURE-----

--HVCoas+krw6dou6l--
