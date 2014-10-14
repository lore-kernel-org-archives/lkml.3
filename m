Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaJNNqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:46:16 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52447 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaJNNqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:46:13 -0400
Date: Tue, 14 Oct 2014 15:46:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@nvidia.com>, Rhyland Klein <rklein@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] of: Add Tegra124 EMC bindings
Message-ID: <20141014134604.GB2217@ulmo>
References: <1412945262-6068-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412945262-6068-5-git-send-email-tomeu.vizoso@collabora.com>
 <20141010131417.GA6004@leverpostej>
 <543D26ED.6040201@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <543D26ED.6040201@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2014 at 04:36:45PM +0300, Mikko Perttunen wrote:
> On 10/10/2014 04:14 PM, Mark Rutland wrote:
> >On Fri, Oct 10, 2014 at 01:46:55PM +0100, Tomeu Vizoso wrote:
> >>From: Mikko Perttunen <mperttunen@nvidia.com>
> >>
> >>Add binding documentation for the nvidia,tegra124-emc device tree node.
> >>
> >>Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> >>Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> >>---
> >>  .../bindings/memory-controllers/tegra-emc.txt      | 41 +++++++++++++=
+++++++++
> >>  1 file changed, 41 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/memory-controlle=
rs/tegra-emc.txt
> >>
> >>diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra=
-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.t=
xt
> >>new file mode 100644
> >>index 0000000..6282c6b
> >>--- /dev/null
> >>+++ b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
> >>@@ -0,0 +1,41 @@
> >>+Tegra124 SoC EMC controller
> >>+
> >>+Required properties :
> >>+- compatible : "nvidia,tegra124-emc".
> >>+- reg : Should contain 1 entry:
> >>+  - EMC register set
> >>+
> >>+The node should contain a "timings@i" subnode for each supported RAM t=
ype
> >>+  (see field RAM_CODE in register PMC_STRAPPING_OPT_A)
> >>+Required properties for "timings@i" nodes :
> >>+- nvidia,ram-code : Should contain the value of RAM_CODE this timing s=
et
> >>+  is used for.
> >>+
> >>+Each "timings@i" node should contain "timing@j" subnodes. One "timing@=
j"
> >>+  node should exist for each supported EMC clock rate.
> >
> >What do the i and j correspond to?
>=20
> Arbitrary integers, preferably starting from 0 and increasing, similar as
> with regulator@i etc. Each set of `j's is independent. (Actually, these
> values are never used anywhere for anything).

Perhaps they should be used, then? Typically the unit-address matches
the (first) value of the reg property. Perhaps in this case it would
make sense to make it match the value in clock-frequency for j, and i
could correspond to the value of the nvidia,ram-code property.

Thierry

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPSkcAAoJEN0jrNd/PrOhchUP/0GRScxnQVDlu+awFc+UP35C
zSVTvjO0LfvE+k5gZsP5sJH98wCIEgAV/4G+pvnkoBuXnh3dqsZSHs8P/5wUwdS0
C3xeQvEgfwUTuwMwl+ln+TzQvfvfEzhNhEvcowkY6KpRDETxDWQ50ZKpuJtarOK6
8NeQmheTTjtsFYk57eteYGL3ENOrD8ey8LT3RBajipJ+5dffXppSXtEFcd/M2kFu
JYVs/8HBGVLFWfmtwaqzD7O2iOEXgNAxJMrtAtW5kG5I9beGMqkC81ZYAG0yIq/j
y9noS5dvFv/ZCP0D/9v1AenHuEso1on+VBvfl5vjJsAozv1HYv9NDRnI6B0vtawn
nWyXd8n3ltiuBPoaLBenz4VyzRgNkmZSFP6FR61yqGrhTh5wLB/lVwcALnOvj1ty
i4xcLSl3gOSL7KvnEUTJMu5i4traqwynJhdR/POToEMu14pa9CSnOfprhlZarVBW
8z9vYN75RQzapMtRQYhalpK1I63JIcpFr/KRGkEO351Qfs+neHqQk9MHXGom9q4P
fonhBj86I/i99N6Ju0VR7uWlqyCNKQ4HtOH5QYQOKM1z5cDriaYfjxdZ3WbiZXbq
tiyJBceIQPtZEH7xBPVdLPrL8Izj4SuPahNfh/QQWR3d8GW1fL+nYcQohFbkT92h
MXlyhdbUuEyxCTNN0srh
=puy9
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
