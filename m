Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3FNN6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:58:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36495 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FNN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:58:00 -0400
Date: Fri, 14 Jun 2013 14:57:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Message-ID: <20130614135749.GS1403@sirena.org.uk>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <20130611142358.GG29135@zurbaran>
 <51B74252.5090906@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/OxAoNYcURhUkoHv"
Content-Disposition: inline
In-Reply-To: <51B74252.5090906@linutronix.de>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/OxAoNYcURhUkoHv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 05:29:22PM +0200, Sebastian Andrzej Siewior wrote:
> On 06/11/2013 04:23 PM, Samuel Ortiz wrote:

> > Please fix your commit logs, and your subject lines. It should be e.g.
> > mfd: input: ti_am335x_adc: Blablabla

> > if it's mostly an mfd patch that also touches an input driver.

> I usually do "subsystem / driver: short description" but if you want
> the ":" as delimiter I can do this.

You should always aim to be consistent with the style used by the code
you're updating - do a git log and make sure your patches don't have
changelogs that are obivously using a different style.

--/OxAoNYcURhUkoHv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuyFaAAoJELSic+t+oim9MHUQAI4k6ZFd3GEwPZgVcptmG09S
gXyleNtbhmtiFGUsZEZDhX8fQjAnGMq6i2fsBQXQv9WcdZNFWuBWyoYL5D9YWm+z
oWmwrsMB9WncNyd1otHRH+k+qRWhosroOtjRSi+oBPGZKE2Nb9BzyUxxsWbmq4iW
Vq5V6KKRX0rWGA6zrD/ZCerQR81A/b+DQWd7UT56GRWIGYle2s7MI7zMXXQQer+u
nXmm/Df7kSdeXDupuepUIyc3dw7c4yfjENM2vvcmIVchXBLEvBpjBGBlTlaPfeJu
Sflwu/pUeeuVJYUXWtDV85Ec3ymVh4YVPjwMeno7dlSow3l5z9SWr22dMgzMY2Y3
mGLwDVkwYx/2Y/jaLrFPR5eDQU7DKBoLFqeN+eh0ZL/vkmmJrfRy+HoVv6WF7yGb
RbU25Z+hJ1dgWvuCFZU/5lpxF/fXBm00rXWgZ3nkOLfbQVupBRh98IwMAFPerQjm
LydU8L8iN8nl/MJLjcwtpN1ODVXhilodAlBk7Zn7GJUf+Id9xybtMKLzixTBGN2a
s1dy6/fpJAX7l8Bwwt7uYrP4kZPVD63YPzm7Z6CEoIcg/s18byxnzoE6eYB4HXCg
8ZGAV7+pam7fe/jR1f6aTpnL8RKrwdujsWlkpQwGntGTgxed1DywWWpf5MCEpOmq
GwRs87ym96jNXPEWvvPV
=vm2j
-----END PGP SIGNATURE-----

--/OxAoNYcURhUkoHv--
