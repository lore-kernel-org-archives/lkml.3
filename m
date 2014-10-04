Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaJDMFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 08:05:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33794 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaJDMFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 08:05:22 -0400
Date: Sat, 4 Oct 2014 13:05:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, tiwai@suse.de,
        joe@perches.com
Message-ID: <20141004120501.GD4609@sirena.org.uk>
References: <1412356628-10818-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <1412356628-10818-1-git-send-email-standby24x7@gmail.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: da732x: Remove unnecessary KERN_ERR in pr_err()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 04, 2014 at 02:17:08AM +0900, Masanari Iida wrote:
> This patch remove unnecessary KERN_ERR in pr_err().

Applied, thanks.

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUL+JsAAoJECTWi3JdVIfQ/40H/iIE64jcNllCsPCd2N/KgrZI
UnIkGS9WgHfR77a0AgDKFv7PdCgzlexA8Sujfy1PywL2GnRTmGr/70XaN+AYnInq
RBoSd426QdsD8LbMMsWDIoOt7xV0iuu9jwk2B9ocTRXZIkbF7qCfO57jtsPsn2p5
edYCV2wQuQoyW+VRGEWTDbujr8kPfz4pbaORVuTG1VfQUbjXK5qdUzX/qenl5EDu
LovZeJ44urgCGWz8BkT7n66/1OsI7P1Y2l8u3o0N98KCyKxUkP9uzSbcZnFkwt0b
Ma64gOr1PbyFjXyARjgFrk0CokbVefXjlrgWd+sCx8lgOt1uQVl5gPMt6MDlLkc=
=pFA+
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
