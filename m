Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaEVJ6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:58:46 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51249 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaEVJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:58:44 -0400
Date: Thu, 22 May 2014 11:56:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] drm/tegra: Convert to master/component framework
Message-ID: <20140522095621.GA11613@ulmo>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 05:30:43PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Hi,
>=20
> This series converts the Tegra DRM driver to the master/component
> framework. The length of the series and the list of people in Cc is
> mostly due to the fact that Tegra has some special requirements as
> opposed to other drivers and therefore requires some changes outside
> of DRM.
>=20
> Patch 1 introduces a helper function that can be used by new DRM drivers
> that don't rely on legacy userspace ABIs. It allows them to register DRM
> devices much more easily and without much of the midlayer that currently
> exists in the DRM subsystem.
>=20
> Patches 2 and 3 make some changes to the master/component framework
> which are necessary to convert Tegra DRM to use it. All current users of
> the API have been converted as part of this patch. Note that at the same
> time the drivers are converted to no longer use drm_platform_init() in
> favour of the drm_set_unique() from patch 1 in conjunction with
> drm_dev_alloc() and drm_dev_register(). I would've liked to avoid such
> invasive changes in a single patch, but unfortunately I couldn't think
> of a way how to do that. I'm open to suggestions.
>=20
> Patch 4 adds a new interface framework that supplements the master/
> component framework and can be used in situations where there is no
> struct device * that a driver can bind to.
>=20
> The Tegra DRM driver is converted to using the master/component
> framework in patch 5 using the above four patches.
>=20
> Finally patches 6 and 7 add some documentation about the new way of
> registering DRM devices that don't need legacy support.
>=20
> Each patch has a somewhat more elaborate description of why it is needed
> or what problem it solves. The patchset applies on top of linux-next.
>=20
> I welcome any questions or comments you might have.
>=20
> Thierry
>=20
> Thierry Reding (7):
>   drm: Introduce drm_set_unique()
>   drivers/base: Allow driver-data to be attached to a master
>   drivers/base: Allow multiple masters per device
>   drivers/base: Add interface framework
>   drm/tegra: Convert to master/component framework
>   drm: Add device registration documentation
>   drm: Document how to register devices without struct drm_bus

Greg, Russell,

Any comments on this? I've been blocking a bunch of patches in the hopes
of getting this merged since it allows the Tegra DRM driver to be
cleaned up a great deal, but if nobody's going to look at or comment on
this I'll abandon this series and keep using the custom solution we've
had for a while now.

Thierry

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfcnFAAoJEN0jrNd/PrOhcpsP/jJFHMbffrXN2ZjLgQVMlX80
8HMVNcrD0pMUp/QdUHQGtT1ZRnnVNaGFWrHWx1MJUQY5xS3RJShPqpwJSj1rB6Z1
FIda1NLNcHaKqzijW1OWW1eRb2M5xIrY9/rf7D9Y20iHK316RG9IyfCR02WB8Vz6
Cd8v8qcjXsKFmzaJeXs4K/dl4M7N70Njz2SaCkt3dIWeqm1sZhh4gF8wr6cdoknL
gM9lCENSf4fbZBU+0bkD7FsnZP5pbxmXKEqHIdeFRJ5QZAopwOCzzhdN3ld8sIxJ
RAYTaG/NXDs1mmTSXyVq1qFRPEwxi+NxKWvaifYNiaW/5+1mVD6xr7B2Ng05Wgcx
jg4v3b/xMxQ/xODjtNUi4y/toUpYRn6Wm293haxucGu8QHfvk2Dh53Ah1WMjOyKa
QIa+hWxFh/YX5+D3vi32ZMOYg+U9rScDQBtAtedvPp5Vz1mSdl0W/2ij4d3ScCD5
rtFsrahN0TUq31Kf2VFIZbmX/MO3ilM8kZFovxjZxP1WPa7N6L4yWfBCr0HcQYwy
ZMFqwU0Q9hr9DMJCk6RtUWClJgaS4pTW3MyWaW+fv4qbmipKUilNiqdBagjRl8YV
zsXa2e6l7eZurZFYY3/P6mtiRTU+h7rVOvaVw/B/zUQZB37kMlzyQJYG0lxMb6Z2
r+Lahcd60sYCTHigWysK
=5/ob
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
