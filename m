Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaHANzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:55:53 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50459 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaHANzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:55:49 -0400
Date: Fri, 1 Aug 2014 15:55:42 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] resource: Add device-managed
 request/release_resource()
Message-ID: <20140801135540.GA373@ulmo.nvidia.com>
References: <1406895311-18869-1-git-send-email-thierry.reding@gmail.com>
 <20140801125522.GC21624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20140801125522.GC21624@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 08:55:22AM -0400, Tejun Heo wrote:
> On Fri, Aug 01, 2014 at 02:15:10PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Provide device-managed implementations of the request_resource() and
> > release_resource() functions. Upon failure to request a resource, the
> > new devm_request_resource() function will output an error message for
> > consistent error reporting.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> Acked-by: Tejun Heo <tj@kernel.org>
>=20
> But please also update Documentation/driver-model/devres.txt.

The patch already contains the below hunk. Do you expect anything more
to be added to that file?

Thierry

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-m=
odel/devres.txt
index d14710b04439..befc3fe12ba6 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -264,8 +264,10 @@ IIO
 IO region
   devm_release_mem_region()
   devm_release_region()
+  devm_release_resource()
   devm_request_mem_region()
   devm_request_region()
+  devm_request_resource()

 IOMAP
   devm_ioport_map()

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT25xcAAoJEN0jrNd/PrOhPuoP/2T18ziutKk3DktygVhk+yNN
Gmu2n+RwBe+lbkSmtli+6Q5Vx+LBPqzLAh7uUWqU+o5KtzRREW3s+9k+unqM/Hwk
gj6YzpipwPr0g5pkXEw/jqbwAI6Hmw9xdIAZlZmOl+TVaYG/kNaEe2nc1SGpCxqb
Exb2qyujAGeUmFpAaYxFY+3bXOfgbsajVJxqoYgiR7TnrotkHBJ+0h5ifcJ8avSh
4VN7So/TFYLpsomEflx6gr30K9eOFaqicgFTIPJSDCjlOA5/M4s4nctaRTLsC5Z5
aYhEV3PHBr3iLRi8CKNjTmfklGcLCIYi61AeibEs+tl6UWaNYsCqGV1YdqGHtCSO
m4MRUsay4J/FiVfX2RolgIFIkDkgmJQAFbMI2c701Dwt2V0TMQjko3QHITxoahV3
fZq6NHg2ozHSDeGWDVYL2ZWvAbLhJhfdjePuURg7BtH5WbHvYL+iLP0OkhdVK8D3
0ZNAW7nBD3U6WyG/WSeR7l0lAKvebQI1Dcow4MqlxzjorpswFiGL2EiSpr2drx43
dHzmYAWLNan1rFfDmI9i4eJP0OK5B5egEwasQ+R6+htB35xyvfanfvuGxYW1w6ER
0o8LBTo5FK/I44+8r2zv/vJepS9fTqKLhnh8J/AmYb0sGJz0yrLh0FcTNabtq/kr
s04NqHDmQRYeisZLELYZ
=bFUi
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
