Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935308AbaKNPFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:05:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38359 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbaKNPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:05:44 -0500
Date: Fri, 14 Nov 2014 15:04:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20141114150411.GB3815@sirena.org.uk>
References: <1415848096-20079-1-git-send-email-abrestic@chromium.org>
 <20141113173631.GI3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2ZXnG0twRSEA0LxK"
Content-Disposition: inline
In-Reply-To: <20141113173631.GI3815@sirena.org.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 0/2] spi: IMG SPFI driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2ZXnG0twRSEA0LxK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 13, 2014 at 05:36:31PM +0000, Mark Brown wrote:
> On Wed, Nov 12, 2014 at 07:08:14PM -0800, Andrew Bresticker wrote:
> > This series adds support for the Sychronous Peripheral Flash Interface
> > master found on IMG SoCs.  The controller supports up to 5 chip-select
> > lines and single, dual, and optionally quad, mode transfers.

> Applied both, thanks.

...and reverted since they fail to build in x86 allmodconfig (due to a
missing linux/interrupt.h it seems).  Please check and resend.

--2ZXnG0twRSEA0LxK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZhnqAAoJECTWi3JdVIfQJE8H/Aj98L8arZae6SFhlU93VbYF
IYx+pmmkZv6VsdArO0T6lM2/yA/ghmISIRpzKeGaxj8ASS06yZ5KE+J4QmB2NRVx
qrcBwejf6YU7WQU3orwpU6KbCTLR8Cg83G3BnSdwwNcIzTEmI3QUVAz44ZhTlZnh
g3H5qz/iLfBfAhEoL+U7fXDX03WSX5S1iVkl5r9CBrlU1weIcWIQIBDIFC1w8XoF
grb3XtizgudFQFC41iNbdzNKMyZltKxmOr9xBux9dbjp8GcHjPiz74ulL2/SBXBO
na9MzNWXuffFelT/kJHxlw1XHva9xd/nPXeICcQgRy8v6f1zBFXSmxzjcdNRiwc=
=/cKV
-----END PGP SIGNATURE-----

--2ZXnG0twRSEA0LxK--
