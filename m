Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbbAWJeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:34:18 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:58927 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbbAWJeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:34:13 -0500
Date: Fri, 23 Jan 2015 10:34:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: Re: [PATCH v2] clk: Introduce clk_has_parent()
Message-ID: <20150123093409.GC3835@ulmo>
References: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
 <1421856780-32103-1-git-send-email-thierry.reding@gmail.com>
 <54C04145.1010906@codeaurora.org>
 <20150122073707.GA427@ulmo>
 <20150122202546.GO27202@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <20150122202546.GO27202@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 12:25:46PM -0800, Stephen Boyd wrote:
> On 01/22, Thierry Reding wrote:
> > On Wed, Jan 21, 2015 at 04:16:05PM -0800, Stephen Boyd wrote:
> > > On 01/21/2015 08:13 AM, Thierry Reding wrote:
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >
> > > > This new function is similar to clk_set_parent(), except that it do=
esn't
> > > > actually change the parent. It merely checks that the given parent =
clock
> > > > can be a parent for the given clock.
> > > >
> > > > A situation where this is useful is to check that a particular setu=
p is
> > > > valid before switching to it. One specific use-case for this is ato=
mic
> > > > modesetting in the DRM framework where setting a mode is divided in=
to a
> > > > check phase where a given configuration is validated before applying
> > > > changes to the hardware.
> > > >
> > > > Cc: Russell King <linux@arm.linux.org.uk>
> > > > Cc: Mike Turquette <mturquette@linaro.org>
> > > > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > > ---
> > >=20
> > > Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> > >=20
> > > This will slightly conflict with Tomeu's  patches for per-user clock
> > > constraints. It would be best if we can take this through the clk tree
> > > to fix up any conflicts
> >=20
> > I had hoped to take this through the drm tree to resolve the build-time.
> > Another possibility would be for me to include the clk tree (or a subset
> > thereof) in my pull-request. That way you can still fix things up in the
> > clock tree if there are any conflicts with other work. We could make
> > that work two ways: this patch gets applied to the clk tree and I pull
> > it, or I provide a stable branch that I base my pull request on and that
> > branch can be pulled into the clk tree.
> >=20
> > Yet another alternative would be to split out the clk_has_parent()
> > change from the series and not use it for now. That way we're going to
> > miss this check, but we do that anyway currently and it will only be
> > temporary until v3.21.
> >=20
> > Perhaps given where we are in the release cycle the latter would make
> > the most sense for now.
>=20
> Ok well let's see what Mike wants to do given that he's doing all
> the patch applying right now. I'd think that we could put this
> one patch on a different branch that we can merge into clk-next
> and you can merge into the drm tree. At least that's the typical
> workflow that usually works for everyone.

I will be sending out a pull request today, so I'm not going to include
this patch or the dependent patch. I'll pick it up again after the merge
window and see if I need to rebase it on top of Tomeu's work.

Thierry

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUwhWRAAoJEN0jrNd/PrOhHqEP/RTXBemkkP5+B53fNu2Z7sf8
GQzKOZi9gjLLsRXxz1tc9TeYVe6V7tVEGxxNMERc4HG8ym/zYg4iDw21tUadatSn
xYpXRj4efwvdSQG3OlWVdBv2sY8H5lFXG40tp6J55EGyiSLARkcElSpE6ikqBMf8
O6qwZi3hGhS5RtjqcvU2p84yD4ZQ9et2/gV5oz3geXlAIaNEtBkTCdMuMXfTJ7yn
0x6otsOR6I2XuaxUpSOLURZcg1bf4SZcQQz1F7HEK04h9Pz3alZM7coMZEPVMSoH
nxiBjjchYUSbnpjwhaEBVcT8s4x1ZkJYELGj3ci8E3P49KitpBA2MzXh+Hn3plG/
2/3EvBLe7OoEgObbEtCl0A4ZYyl1S64My7oYTHjNdWhj6M4ZVlUtBlWcNdk5cYfo
JidkG+EmBR25e70k8qxmbonqF0cur7Rw0ZkeTzhVHySYxRd9njdCwuMNMsywwttp
95iqnjtVC7K6SpSTgkl/PhA3qSS2oWSDxFlLYsGS8yZKmMn/NaJ8tbTZ1ZYe7CkZ
VssKR/kbfDs981KnjsohkQ3FL7xf240MqZJNqHOUf+hGLQXJBbz+Lew/z8PaDAAL
gpqU+kGjCcuUAsuW5XYWDU/M6EjiGAMBN44SaodfO1UXDFcTBAPcc9sXH4Gfk684
S7YQY46Gl0JMSqi162JZ
=jJ6d
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
