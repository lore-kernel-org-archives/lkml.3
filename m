Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbaJHMuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:50:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40601 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbaJHMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:50:11 -0400
Date: Wed, 8 Oct 2014 13:49:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141008124935.GA24947@sirena.org.uk>
References: <1412671438-25399-1-git-send-email-zyw@rock-chips.com>
 <CAD=FV=W_6_JSn5ZWEG7YBDw5xf+tGReSB-WCV798gBqXyhikgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <CAD=FV=W_6_JSn5ZWEG7YBDw5xf+tGReSB-WCV798gBqXyhikgg@mail.gmail.com>
X-Cookie: What fools these morals be!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Add support setting suspend voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 10:48:41AM -0700, Doug Anderson wrote:
> On Tue, Oct 7, 2014 at 1:43 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> > support setting suspend voltage and disable regulator in suspend.

Doug, please delete unneeded context from mails, paging through screen
after screen of irrelevant text on the off chance of finding content
gets old fast so it's likely that some or all what you're saying will be
missed either through boredone or error.

> One point of curiosity (maybe this is a question for Chanwoo and
> Javier): I'd expect that if someone didn't explicitly setup a "suspend
> voltage" that their voltage would just be left alone at suspend time.

No, this is not the case.  The suspend mode settings are a completely
different set of settings activated when the system goes into suspend
with explicit hardware support.  If no configuration for this mode is
provided then=20

> I believe that won't be the case for your driver.  The rk808 will (I
> think) automatically transition to the "suspend voltage" settings for
> ALL regulators at suspend time.  If you didn't explicitly set the
> suspend voltage then you'll move to whatever the default voltage is,
> right?

As ever the hardware configuration won't be touched by the kernel unless
it's explicitly told to do something.

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNTLeAAoJECTWi3JdVIfQoGwH/0hJgyPdrO3knMrlBVSyDHGC
OkkD+kL20fPkmrbjRJfnjCm+qP7vGY8UIfnSfv9+ZzK5SLlGgTNNn4feldHuDgDt
VZGNSAcbsdKkcG2V3Jwy7dCPCB6pKZTcNTSbvxRoSHD14Vk3FP2e/Hxq28qMkfcP
zDcPZ4M7fUydrNTPltTTe36nu8sR4qKPq7lLy2eineq1yhpcsXqoHb56dSxB7yW2
PIxiEkJzzjiD+fcI+Lv9uG6c0dXsd1IsJVXR0anMh/YO+jf+tDta9xlSf3xkCdzF
aWWKnyNeq4U3trWum3PeSa3/2MRi7ckKDEvvPDGJGgyNFRxfGJeE4NiIBctMgIo=
=JYfG
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
