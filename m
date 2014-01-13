Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaAMMk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:40:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53537 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaAMMkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:40:25 -0500
Date: Mon, 13 Jan 2014 12:39:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140113123957.GW29039@sirena.org.uk>
References: <1389604624-8412-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f3bMXCeKxSopGW1v"
Content-Disposition: inline
In-Reply-To: <1389604624-8412-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: initialize DMA channels to -1 to prevent
 inadvertent match
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f3bMXCeKxSopGW1v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 13, 2014 at 11:17:04AM +0200, Mika Westerberg wrote:
> Commit cddb339badb0 (spi/pxa2xx: convert to dma_request_slave_channel_compat())
> converted the driver to use ACPI provided DMA helpers but it forgot to
> initialize the platform data for the channels to -1. Failing to do so will
> result inadvertent match in the filter function because 0 is a valid
> channel number.

Applied, thanks.

--f3bMXCeKxSopGW1v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS096aAAoJELSic+t+oim99KgP/0XLE/lptX3h53+oRLUhELwK
/J9ZUeO4i/9vnNnq+HD6/uHz0V2FYo8uq0G9eKqUF46tp3TY9a/xiFqdP1q+kq1Z
bFZvdDRca/0ptJKNtwJpfaxhh7zlrcKufPvEZ5tnl0nQ7vivyDIQYUsmzkJne+Ja
lDFJ72F27ChN9mahXIkYzGoiesNkinaxFWvOVp/xdyvciIUjwEdmTdwFfKTWgtjM
YJJ95MOf5Z421NMBMcVem0zRMu0P+mC12y4w2VBsXrqbrqhwW07RKxBy/iME0HbJ
uA8fjwDzAAyanskJXuMdc/hhFyCD/uWvqb1MelS/fDQwJnqVNUJByMurG5AZNzv0
TZBLnr0083O/hX2Nap7raCmZKz1Sa9YESfAZlc65JIQjRgTMJw8+N1eFubpYzMRB
LNUhVUPma9Y8wsgfOBWCThZtafdDpbWW7WDxC5v5KGV9r45u+l/xqCLgFG2PPIk7
i+WFBq1xdz7/CH613tr8du2V77W1YmlyjhLOeSEFAl8iZE+oVwVuJjCQS2th+NOM
KSj8xPBFUem/T3E+twVn0MVB5sZfF2v0Q4iZp7Ijz07Ix5AYgd+DqaHgZUXd5WBC
Ge9/FubNEjv4RK0qiysMKeEcH8j4iZ7osMDhYVe+px/t/iJN5+EuK5wBYKlETjIk
KmFbVltuqPzGz2QZ1sP8
=vurY
-----END PGP SIGNATURE-----

--f3bMXCeKxSopGW1v--
