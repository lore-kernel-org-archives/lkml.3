Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaFSNnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:43:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52321 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbaFSNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:43:38 -0400
Date: Thu, 19 Jun 2014 08:43:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv2 6/6] usb: dwc3: host: convey the PHYs to xhci
Message-ID: <20140619134330.GA23782@saruman.home>
Reply-To: <balbi@ti.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1401972778-5880-7-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1401972778-5880-7-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 03:52:58PM +0300, Heikki Krogerus wrote:
> On some platforms a PHY may need to be handled also in the
> host controller driver. Exynos5420 SoC requires some "PHY
> tuning" based on the USB speed. This patch delivers dwc3's
> PHYs to the xhci platform device when it's created.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Felipe Balbi <balbi@ti.com>

if the rest of the series gets applied, I'm fine with this change

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToukCAAoJEIaOsuA1yqRESHAP/RH7+llSjaspPZrue8kV+DGh
7bpp/OpVHmB0DQ/84QoZtBReH29KMnPhqlAHrpsWWYmuyKlCwAiTLxhxP3wmVTIv
23L/r2pCgzTN1wKuPA+UaJLdlXW1ZeriR+lMjMyLfUQb8LPbXc1+BHs5ny0gtxTA
cPx0daa8OqNrd/wsT8AkORX8umRHt4QiR6emxL2HlLqZuk6QmNlj+4w++dvwgSZd
U8WkqG7klByZi+Nf727+TO2JvLQaxNgVyCJIBQh6p+GqMVW0s76WyjqjG3w+7X7T
r1G8939IqbR1bMtenLTNRDdk0YFxI6AFLPonQz6sBKdVkLVWNGtRWWaPIuvtv9Cq
aaJlTCXWWvgqs0s/vliaPYOU48eYaMmlXqHtQk/boewpOD+4jBZ523TPIwaYhGpA
6xnq7ibntxMEy9cZhE07SqO2rOt0M3CQ4N7XdQidrlnFHdsIkqaR22RVFsckyKAC
5k8ktc7pPfWUCSYvQqkeY10zDg77yNvMCvn6hZvF9TdYIVOPl62xhRmSs1NYel+Y
zh337QTa2xviDzZsuLo3WqPgH88Jxo+PaQjpqzkSFxRIUXZPegYROsi1Wqzs4lCv
qX77+Ckpqj4SyiaaS2TpA8veez1pW8ExyUVHFyPMQ8AkoJRlK0hS19/ZAU1xSOrg
/uAE1dR3wd2KtI37nrJ1
=fpUL
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
