Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaDRPIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:08:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37944 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaDRPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:08:43 -0400
Date: Fri, 18 Apr 2014 16:08:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140418150804.GX12304@sirena.org.uk>
References: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397727612-32103-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E4MLQwZ4UyBg1Kd7"
Content-Disposition: inline
In-Reply-To: <1397727612-32103-2-git-send-email-boris.brezillon@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] regmap: add reg_read/reg_write callbacks to
 regmap_bus struct
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E4MLQwZ4UyBg1Kd7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 17, 2014 at 11:40:11AM +0200, Boris BREZILLON wrote:
> Some busses do not support sending/receiving multiple registers in one go.
> Such kind of busses just unpack the registers that have been previously
> packed by the regmap core or pack registers that will be later unpacked by
> the core code.

Applied, thanks.

--E4MLQwZ4UyBg1Kd7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUT/RAAoJELSic+t+oim9MV0P/0ZkgsEXTSRjEGw7BhYfq91i
haMBjUskSFxbLcqKeC2brmCv/eSs/GJ6eHbLoxD/1btu4VnlJ4vpDadJaCrD2Mx/
7BmFLcpz/6zfcX157MNLnanHrv+yb8v9L8vcnsneiRT1bdt1jwRhRiBa7EEM6IzO
4jIAm72neHZmE8faJtzvxssQ9shSWDBR+YRz3UK1S9tU3/81W6EljE8/wlfI56Nc
f80kJ7dUO+S18WBiV9Aoqohl8cKG+UFDsXJO+2eZUcG5BL2rRq6op6dyhi84CxVe
eXgLkz385sEJdgUambBzAJn3l4IXy2anAqa26vjqJmebQNZk3Ih56BXcORQ1dbeP
caG70x3zPMrabOqBYffuvGYBVSISTXQOwcwhc0wx96+2H1djgGP6QXBp9GLnwnul
e7PQ94LrFytvZLfrFHRNvEregXiNNZQPqakPPbhf0ZFakuoJqPEF/NwxWRANZLzH
Rivzo3RgfKzRqatV84wL0NXc0mBD3bGNyMEwwKcEWneruLtUUO9B6YTUhV9L1TeB
hRuPY2kEeQXThV6ON7iF5GfGaDrYoWbwAwJi7nSw1Zj5ecTlEoPpMAqznsvXpZ+B
qfo1GaODUOoFAeui/BDUDvBa/dTNiiTIhCKa6rj7VTBpi21uwGkmn54z/kjr1sAm
56tTuMe1vIp01qeCxUb2
=1lV5
-----END PGP SIGNATURE-----

--E4MLQwZ4UyBg1Kd7--
