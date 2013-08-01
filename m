Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3HASrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:47:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43749 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3HASrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:47:08 -0400
Date: Thu, 1 Aug 2013 19:47:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130801184703.GZ9858@sirena.org.uk>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com>
 <20130731132522.GP9858@sirena.org.uk>
 <20130801151336.GA1112@opensource.wolfsonmicro.com>
 <20130801152356.GW9858@sirena.org.uk>
 <20130801155056.GA3996@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z8BTbqcYO9MpMRm3"
Content-Disposition: inline
In-Reply-To: <20130801155056.GA3996@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: core: init delayed_work for codec-codec links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z8BTbqcYO9MpMRm3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2013 at 04:50:56PM +0100, Richard Fitzgerald wrote:

> Yeah, I think the problem is more one of bad naming. I should define that
> function as the delayed work for codec-2-codec links, it just happens
> that we don't currently have to do anything for them. The only thing
> the pcm close_delayed_work() does is to send a SND_SOC_DAPM_STREAM_STOP
> but for c2c links we never send a start anyway.

That makes sense, yes.

--Z8BTbqcYO9MpMRm3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+q0kAAoJELSic+t+oim9qa4P/jZktsjkX9y7DrQmGcfk1yWy
dKOsbKB18dPRxz5izXd90e2lQ3/6Vwj7X66WQj09Z0CNAbHwkK/r1D/xQB9Rf6XI
ivx0+IVtXyX0rLvxgzskZlT7zaURchpE/yhxXE6vultYM1QQGwl/dwWykV1XnSlW
mi2UHauj6JkorFrrfSkYb8ofRxFssXpkyxPHnCOnd6uXdI0bWc43622KGE8sNQCo
6nfthhkmFRSIZPYPCLBTxu9BDc1wJYjaekW0sUJym16OlZOGzKe9k3I7fQU4buv1
HQyxdDM8pHMUUI9P/4IN+BxY7W3Ci1sC9aWhk/tX90EEZH+2t68UZNosmxrLKdeV
3Bho/ZML4h8P4QpwpqyV2x8Du2q0poOEoMGiJsf8WWycnVsdeGZgBuwEcqtXWMXr
0aAm3BAfTP45115Bw/7VsxrQCoU3VknJY8otLHnwQsAPiynhr0sXIUeA+PBNYykc
RCltkqf4cZbp7XebtUcWdXm4DQSjQOKpkC3+BQtimrF9d/sSLcO0/S9Ufkid+Rsd
TSBCf8YSo4cjAzzoOICCuLxyuoOjo8twb1xVBrhB9KyZ4YJz57XFPfVjKgUmnq5W
vJnWQGOvmWi2qMM+xIwMJ4PF/HhzgAaP5P6E2FnGRFS+N6S9LQVcIs70kOB3awl9
wzkhUTGXURi+LxFwY5zv
=KzRg
-----END PGP SIGNATURE-----

--Z8BTbqcYO9MpMRm3--
