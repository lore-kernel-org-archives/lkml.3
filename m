Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbbAFRi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:38:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38896 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbAFRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:38:52 -0500
Date: Tue, 6 Jan 2015 17:38:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150106173838.GI2634@sirena.org.uk>
References: <1419997154-860-1-git-send-email-b50113@freescale.com>
 <1419997154-860-4-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ca5z/wkVxIQXz1GF"
Content-Disposition: inline
In-Reply-To: <1419997154-860-4-git-send-email-b50113@freescale.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH 4/4] ASoC: wm8960: Fix capture sample rate
 from 11250 to 11025
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ca5z/wkVxIQXz1GF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 31, 2014 at 11:39:14AM +0800, Zidan Wang wrote:
> wm8960 codec can't support sample rate 11250, it must be 11025.

Applied, thanks.

--Ca5z/wkVxIQXz1GF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrB2dAAoJECTWi3JdVIfQelEH/jL3UfPiaRzgn07S0BCZi4dj
MN9Eyrgraz7g2bmIsii6ghhzARo7HIrjzzGYZKP5Adwf7cwOa8km47jliNUs+3/w
TBKIKFEa8Qo1y9e8d0ba3FrXnVZ5/5PqBHAihzj9Wbq/ddUvUCDW+MaNZGVMPWhd
g4ekY4plljK8G+J04efQMUdPNZ227z9B3CQprTfsfM4yXLcJbSKzV49BQ3N1S2/P
k6E9SCNRX9djUc1ktn5Px87Y/ABZyIH96Im7B+hJSoTEGCh5/EH3MpPBvNwnCdeY
Zv8pcb/8eltBe7JGyPGHPLttUI0l4bI2p6XNvJZFJt/IppGmUuN5aB62FUXrDgA=
=zWwH
-----END PGP SIGNATURE-----

--Ca5z/wkVxIQXz1GF--
