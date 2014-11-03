Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaKCMbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:31:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35309 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaKCMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:31:18 -0500
Date: Mon, 3 Nov 2014 12:29:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Chris Zhong <zyw@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20141103122948.GI3815@sirena.org.uk>
References: <1414813978-32233-1-git-send-email-dianders@chromium.org>
 <1414813978-32233-2-git-send-email-dianders@chromium.org>
 <54549EA6.5060007@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Li7ckgedzMh1NgdW"
Content-Disposition: inline
In-Reply-To: <54549EA6.5060007@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: of: Add support for parsing microvolts
 for suspend state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Li7ckgedzMh1NgdW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 01, 2014 at 09:49:42AM +0100, Javier Martinez Canillas wrote:
> On 11/01/2014 04:52 AM, Doug Anderson wrote:

> > +
> >  		of_node_put(suspend_np);
> >  		suspend_state = NULL;
> >  		suspend_np = NULL;

> Looks good to me.

> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

If you're reviewing something please don't quote the entire patch, the
same rule applies as always - just include relevant context - and
especially don't include your one line of content at the very end of the
patch.  Otherwise people have to page through the entire thing to find
what you've said (if they don't get fed up first).

--Li7ckgedzMh1NgdW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV3U7AAoJECTWi3JdVIfQlF8H/3LdFJsLZB4biSLe3cCaSs7c
sWcHymCur8f0lh9yQZWFU7tTRFbJu3iC2b/vjjVQ7iVit25QZqKFrlpDpCPTDv4+
nKct/dG4FZI0EnBd1J1JqPX0qJjacE7mI694eQReh8/SbBPVE1DtvAxQ+MXO//uR
OwiEJ3lZ/WDT52YLErHKGGRSoI8mNaEipSTxc5+TV1lN/oqChESj+qpZ0+OmawOl
8npFptHaSFeyxrN3iz1O2BNYYltFdxk4iCcPFEGzZ0+Kf/gK9UL/WHF9WQqifvMz
GgWpKzbtNZXcwb+vkH/2YTvFA8dcTON5drIpG1FGDE17WLxQvilR6qHDiWCMWrw=
=k+Xy
-----END PGP SIGNATURE-----

--Li7ckgedzMh1NgdW--
