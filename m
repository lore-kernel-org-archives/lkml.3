Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbaLDUOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:14:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56460 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbaLDUOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:14:31 -0500
Date: Thu, 4 Dec 2014 14:14:31 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Mugunthan V N <mugunthanvnm@ti.com>, Nishanth Menon <nm@ti.com>,
        <bcousson@baylibre.com>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Add DRA7xx CPSW Ethernet support in Device Tree
Message-ID: <20141204201431.GB18419@saruman>
Reply-To: <balbi@ti.com>
References: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
 <54463063.80207@ti.com>
 <20141021172223.GA12943@kahuna>
 <20141103162722.GN27425@saruman>
 <545BA9EE.1040905@ti.com>
 <20141204201401.GA18419@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20141204201401.GA18419@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2014 at 02:14:01PM -0600, Felipe Balbi wrote:
> On Thu, Nov 06, 2014 at 10:33:42PM +0530, Mugunthan V N wrote:
> > Tony
> >=20
> > On Monday 03 November 2014 09:57 PM, Felipe Balbi wrote:
> > > On Tue, Oct 21, 2014 at 12:22:23PM -0500, Nishanth Menon wrote:
> > >> On 15:37-20141021, Mugunthan V N wrote:
> > >>> Nishanth
> > >>>
> > >>> On Tuesday 21 October 2014 03:30 PM, Mugunthan V N wrote:
> > >>>> Adding device tree entry for CPSW to make it work in Dual EMAC mod=
e.
> > >>>> These patches were tested with DRA7 hwmod patches on top of linux-=
next.
> > >>>> Patches are tested on top of Nishanth's PM tree for v3.17 [1] and =
pushed
> > >>>> my tree to [2].
> > >>>>
> > >>>> Did a boot test with CPSW and ping test with suspend/resume, the b=
oot logs
> > >>>> on DRA7xx EVM are posted at [3]
> > >>>>
> > >>>> [1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17=
/cpu-idle-suspend-dra7-omap5-framework
> > >>>> [2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git v3.17=
/dra7-evm-cpsw-v3
> > >>>> [3] http://pastebin.ubuntu.com/8613072/
> > >>>>
> > >>>> Changes from v2:
> > >>>> * Changed pinctrl comments to hold mode0-name.mode-selected-name
> > >>>> * Changes slave numbers in the pinctrl comments
> > >>>> * Added cpsw and cpts clocks
> > >>>>
> > >>>
> > >>> I have not added support for dra72x-evm as it has only slave no 2 p=
inned
> > >>> out and having issues with bringing up the interface, need some more
> > >>> time to submit the patch, in the mean time I have submitted dra7-evm
> > >>> support only so that people can use dra7-evm on linux-next.
> > >>
> > >> Quickly tested as well:
> > >> http://slexy.org/raw/s2vISJxYrR
> > >>
> > >> Please feel free to add:
> > >> Tested-by: Nishanth Menon <nm@ti.com>
> > >> Acked-by: Nishanth Menon <nm@ti.com>
> > >=20
> > > I've used these patches with X15 (DRA7xx-based yet-to-be-released boa=
rd)
> > > with v3.18-rc2.
> > >=20
> > > Tested-by: Felipe Balbi <balbi@ti.com>
> > >=20
> >=20
> > Ping on this
>=20
> another ping on this

oh my bad, it's already queued for v3.19. sorry

--=20
balbi

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgMCnAAoJEIaOsuA1yqREJSsP/jF1D/KtAq1I9VXtTjrgpdDa
KGcRF2gZAKFCPVSSKBEXdUtE67nvHy3K9zAq6MZvYCN47F41CxFNhmNybP9HrT8I
AX2aaVMvSh4HN49ZZSgpG98EVQgnrpy0wb8UCNpwgE7ODPEpVA7oPmiv+lRkpufG
qSMpHM1rkFfHAYcSt10LTM+0KYGeCxurtU34hXZNrtx4d7x/3TL0SP6P1Z6/HgcE
JqDgIiRzh8SziRb1rvHO560Vbz5w5x0MmpoF6NjGpDrFS1TSra7wOlqgGWdzk+iL
TOP267bkC8iIZQRe2cQb88Mgu+wBZVGlqEbs/6OzfLgcug7wQn6K4MKh6qI6v+ks
7i8c0YfWzrBljGO6NXS3gUJ0SlRDxoQIAknFOkII+clOMLfLUjKJscsZlYGZYRGV
My+T3Jx4BRrlsknmsen8C7KcBzdlmqKZGVYYH6HR2P6a2x4L9hRVAouxUlSjEtxg
nLomW6PKE7Q47Vac+gEVBjBAbB9CHax81WH9iwQa49Ty0SKy7i2HbzoXznEEXM+j
89ICeEYzO4u84leX+ta3hTqHmW8p27MAiiPkeyswj/qHNBdDeKOjoQX0LLR+6R+V
A+BFqRa0W623p5FBvTDKXGmxYUsXc7Sq5M4VGpw0zkYhYx/vLD8chroEwy5MFxvI
T+jZ0EbOdfpSRNotYfUK
=eJmI
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
