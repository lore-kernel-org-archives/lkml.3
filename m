Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaIZKBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:01:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56253 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaIZKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:01:07 -0400
Date: Fri, 26 Sep 2014 12:01:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sjoerd Simons <sjoerd@luon.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
Message-ID: <20140926100052.GK31106@ulmo>
References: <1400491450-19223-6-git-send-email-acourbot@nvidia.com>
 <20140925132717.GA13579@dusk.luon.net>
 <54243931.6050804@wwwdotorg.org>
 <20140925164109.GA30382@ulmo>
 <1411668631.24948.9.camel@luon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8SdtHY/0P4yzaavF"
Content-Disposition: inline
In-Reply-To: <1411668631.24948.9.camel@luon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8SdtHY/0P4yzaavF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 08:10:31PM +0200, Sjoerd Simons wrote:
> On Thu, 2014-09-25 at 18:41 +0200, Thierry Reding wrote:
> > On Thu, Sep 25, 2014 at 09:48:01AM -0600, Stephen Warren wrote:
> > > On 09/25/2014 07:27 AM, Sjoerd Simons wrote:
> > > >Playing a bit with todays linux-next on my jetson, it seems this pat=
ch is
> > > >still required for enabling the GPU. Is there anything blocking it (=
firmware
> > > >not available yet in liux-firmware?)
> > >=20
> > > I think initially I was waiting for the DRM patch "drm/nouvea: suppor=
t for
> > > probing platform devices" to be applied, but it looks like that's been
> > > applied already, so only patches 4 and 5 in this series are still
> > > outstanding.
> > >=20
> > > Alex, wasn't there also some issue where the VPR register had to be
> > > programmed, and if it wasn't there'd be a hang when the GPU registers=
 were
> > > touched? If we've added code to Nouveau/tegradrm to detect that and a=
void
> > > the problem, then I guess we can commit these last two patches for 3.=
19. A
> > > resend after the 3.18 merge window might help.
> >=20
> > A patch that programs VPR was merged into U-Boot (though I don't think
> > it's made it into master yet).
>=20
> Assuming you're talking about "ARM: tegra: Disable VPR",that has landed
> in u-boot master and released as part of v2014.10-rc2 [0]

Oh, good.

> >  I'm not sure we can reasonably check for
> > that in Nouveau, given that the register is somewhere completely
> > unrelated. In fact I think the U-Boot patch was triggered by some
> > discussion about how to solve this and it was decided that it shouldn't
> > be done in the kernel, but U-Boot should set it up.
> >=20
> > That said, perhaps one solution would be to make U-Boot enable the gk20a
> > device if it's set up the VPR and disable it otherwise?
>=20
> I guess in that case the vdd-supply should still be added to the dts
> with u-boot toggling the status field of the node?

Yes, if that's what we decide on then this patch should be modified to
remove the status =3D "okay" line.

Thierry

--8SdtHY/0P4yzaavF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJTlUAAoJEN0jrNd/PrOhW8UP/1Fw3jyTPEPzb8Ek92frb80+
NS38EG3/8XJSCBtTB+6eVwrgpezPQbEGE/X7Uw+SAnQzqsOv4/R6qz9riJDwRXx5
bjbCq77qPUlKJVe0b1mctDvZzuWHtVrexF/ohkt6BVz4DNvtV+MktyTTAuKR33x6
e7r/xNDgDXHt++bym6r5s2G6Wm0gGQfyCsn8EP/rOGENE+mEhA61tLdTlzzXxpPq
vOkNDDIGNflzYmy5j8i5OsDhJCC91zf0032pFZcyCxZKk2J/0ZRnfEDrLtvrJ1Gr
60pnjjeqARknW+3UjkBZP65oRDrA0IHWosmAKuaK41glq4B2LvzOdTOqI4eoD6xE
M6xUwWqgAJ1gZH6h6Xa8vREsAHCWn+BETSk26GtHefL+4ARoZ5ReQc6hLLV3m8AU
MTDgxYe6yoW/U1D9Fvb8TZkbnHP87Vnf+PEOY4HiDwSTRoZMVogcMqw9CzMAIFUs
yw6xddlVnFc1Bz6T+KNzCVOeDLnuszE2wj91EXqfMzjCpKzIjeag+xLcYO5kRmtB
P+Xr6Eq6vTbRX5bvTXEluOHlmPhshDvkHEybaIPQjoZON/N+wcoj6yEbMnNX0cLH
cfHOUkLgC0UMybB5afgm/n99pPU8vpkiTA3Cyw9aSWNaZ4BYmV6peB0NccGWURY/
MLLwOaGtnHs6bd4FwUCM
=rgSB
-----END PGP SIGNATURE-----

--8SdtHY/0P4yzaavF--
