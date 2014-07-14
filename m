Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbaGNGFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:05:20 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37811 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaGNGFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:05:12 -0400
Date: Mon, 14 Jul 2014 08:05:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] ARM: tegra: roth: add display DT node
Message-ID: <20140714060508.GA2081@ulmo>
References: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
 <1404822734-8603-5-git-send-email-acourbot@nvidia.com>
 <20140711131421.GD10827@ulmo>
 <CAAVeFuKMU3vpDoog-k3X82OZn1VR5iRMpwo5LSeX7cPMOqfXVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <CAAVeFuKMU3vpDoog-k3X82OZn1VR5iRMpwo5LSeX7cPMOqfXVg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2014 at 11:37:14AM +0900, Alexandre Courbot wrote:
> On Fri, Jul 11, 2014 at 10:14 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Tue, Jul 08, 2014 at 09:32:14PM +0900, Alexandre Courbot wrote:
> >> Tegra DSI support has been fixed to support continuous clock behavior =
that
> >> the panel used on SHIELD requires, so finally add its device tree node
> >> since it is functional.
> >>
> >> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >> ---
> >>  arch/arm/boot/dts/tegra114-roth.dts | 22 +++++++++++++++++++---
> >>  1 file changed, 19 insertions(+), 3 deletions(-)
> >
> > I've applied this to Tegra's for-3.17/dt branch. Thanks.
>=20
> Thanks - how about the other patches of the series? Ideally this one
> should be applied last.

Those will go into separate trees and I haven't gotten to those yet.
I'll probably apply them later today.

Thierry

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw3MUAAoJEN0jrNd/PrOhs+8P/R71NN/w/x8f5TVbiQ5t5l7z
s1qs+h8YRjF7k6cBG73X7l/e/7fhhn0Yq9IfaX/bGYF5YcmKEYd65orm8dOqrpcs
c6qgCiaXr4bl+5jXt3PKHC8ehXI7SnO/pQh3DDvtHVMOuEgvq3Kg1t4JZ2Cz+WRn
MAe72bZlj40Ue+bXXa93kr0hTna1H2XAQGd87V/bjcOBmRE84ZAb/OHODbw35QDm
Gc7BE9gAfrqdDtvW9YntVW3CUmpvZlzZAYXqAeZTh2tE2QrDHpchOwTKbgVQM1VU
z/j5vMqgh3Pilv1B2dzaX4GyNDIon3C2D/f7AqxP1ch5jfUk+e73yyhqjn4aPGhY
29x0sYcvTQ8eNuXBmjtDsgXvKBx0LUMlx/w4Xae7QmUQrJJ97h8gJ6b6snwpoaEc
ujq2mo+TALuFBU+VtLwbAB28upkgfW1es2VbERg1OdcvqLGzoOHbqGohSRGLf6Yg
ASBm8aWr4uFLGFLugDF9H8f5kbypA5WKBA+Up1wKWs6Wh2TOAlhqtNePps2daSL4
1q9CVT25chLS9I+m5Re7EURqlnRVvRkqUim3ctgXfQOFn7vnqhNtxFcH3a9Ijk80
KqGlPxfZW7+Ap+tXoTGLS7cLwivB+FIee/dd1sxjh1VInBC1HMEli+NOydTsgDaf
aNPoC8QaJgYW9zIHjwD8
=0jhA
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
