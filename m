Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab3CLSud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:50:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36290 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932302Ab3CLSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:50:30 -0400
Date: Tue, 12 Mar 2013 18:50:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH linux-next] ASoC: wm_hubs: Silence reg_r and reg_l 'may
 be used uninitialized' warnings
Message-ID: <20130312185027.GR19942@opensource.wolfsonmicro.com>
References: <1362934701-75951-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSu31lw3TgkWXnjh"
Content-Disposition: inline
In-Reply-To: <1362934701-75951-1-git-send-email-tim.gardner@canonical.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xSu31lw3TgkWXnjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 10, 2013 at 10:58:21AM -0600, Tim Gardner wrote:
> Return an error from wm_hubs_read_dc_servo() if hubs->dcs_readback_mode is not
> correctly initialized. You might as well bail out since nothing is likely to
> work correctly afterwards.

Applied, thanks.

--xSu31lw3TgkWXnjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3jkAAoJELSic+t+oim9CSIP/RFVcTmc22XxZl8Q6p/trVEr
omNQG590T5Jp32Ge0SkGvsPDrRXuhpbqMqO5PHvt9zhlrgkKMZQ+P4MW5s2FxJxR
nkKOrXyywafb3gocGcW3p7CZaFAIFCGa0E5fJT5lJXnnSlMb+/0y9NTPdA7Vd34H
6LyEAD0VGk4AD11pb4WlZEzP7X669uMiX4sJVTSndNB1v+sFTCEzTqGEXdk5vUeX
CDhQiuGVpp/U3u844f1HaMoeLZaEGXcEjI76wPg2b6g9g+1QDLVYjYS9NxW+binp
fBean9HWdF011zNfd0aaX5X2xe3t1W2K3ZzSrsvy66pe5XRkpOtKd2BvFpaEhHpT
9UW5GcWisaA1c7IEoEEvyk/iR0F1qkQdWbBF8YLnjBM0aYuQusRZbdwbfjoWTeAw
cq8g4WYXxJtjcOKCxiLkFvUNatbnFbeJxgrXNXmHcsP6i3tFSyn6qC+UT5tqTzLB
nylTBa21Bv8T9CK43XmBN0u5RtANv4TVG6oEiQ6SNEWAXM3H/osXy7pVRp4K5zBS
Jg7qBPH9WHy/RMnJenUr2oq/cQ2dzVElZCfRp7UoXUIOd/hNIsftxgEjSOi9VDIS
q6A4maRo7ik6y9uULCw4mV01f1BgGwC5JZANvARAHhVCrpqTXvXNauYhY3rrlB0w
HGaWJtKK9kYGWZ1b5oWZ
=/4gn
-----END PGP SIGNATURE-----

--xSu31lw3TgkWXnjh--
