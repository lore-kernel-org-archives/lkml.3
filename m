Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3FDMNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:13:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36012 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FDMNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:13:46 -0400
Date: Tue, 4 Jun 2013 13:13:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Tushar Behera <tushar.behera@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kukjin Kim <kgene.kim@samsung.com>, grant.likely@linaro.org,
        Kevin Hilman <khilman@linaro.org>, Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130604121317.GB31367@sirena.org.uk>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
 <87sj1qzaov.fsf@linaro.org>
 <5191AA89.6010901@linaro.org>
 <20130528231740.GA28879@quad.lixom.net>
 <51A57D39.8030506@linaro.org>
 <CAOesGMh50Dzr_jczHZC5_txfW=6a+7EgFKvgZgj9MhUcVUTJ1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oAjj1ZwgLg4oRN9q"
Content-Disposition: inline
In-Reply-To: <CAOesGMh50Dzr_jczHZC5_txfW=6a+7EgFKvgZgj9MhUcVUTJ1Q@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen
 board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oAjj1ZwgLg4oRN9q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2013 at 10:31:41PM -0700, Olof Johansson wrote:
> On Tue, May 28, 2013 at 8:59 PM, Tushar Behera <tushar.behera@linaro.org> wrote:

> > e. usb: ehci-s5p: add the HSIC port initialization
> > f. ARM: dts: Add USB gpio entries for Arndale board

> > I am not sure whether such kind of board-specific patches (e, f) are
> > appreciated in the drivers. But that is all we need to get USB and
> > Ethernet to work on v3.10-rc3 kernel.

> I've come across a similar situation with wifi reset sequence on the
> chromebook. On the product kernel we added some code to the board file
> to deal with it, but if we keep doing that things will grow out of
> hand.

> I don't know if it'll be unpopular, but I think it's time to start a
> drivers/platform/arm for these kind of things, and have those drivers
> probe on the system compatible value, similar to how x86 does it (with
> DMI tables). At least that's my plan for approaching the wifi
> reset/power-on sequence on the Chromebook. I hope to have patches in
> not all that long...

This does seem to be a fairly general problem for embedded systems with
devices on enumerable buses - it's even worse for things like Slimbus
where the expectation is that many devices will spend almost all of
their time powered down.  We probably need to come up with
infrastructure to enable the drivers for the individual devices to
handle this, or at least roll out such infrastructure more widely, IIRC
there's some DT stuff for PCI.

--oAjj1ZwgLg4oRN9q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrdnZAAoJELSic+t+oim92g8P/iYtr5vpvwfVw/2NlFdmUuZ+
caoQRHBnOzjZBTKX/U30IxtFLUAUy4izXOo6IIRVMpR/JoCjQnY2ZJMXreQvml1R
0WXH9HtM7IJSLDFq0WMyHjuFBbvtpy9EVVutN5OGffVjAAaENJgDK+aMAovX+HFF
FqB5CLx7KEA56tN1fUe81WFsvk+7PWUF6apYuDcfubVWzFEq0dxVH+rm+w5iE1il
lhwB31KpMNstb8jVVMksZxwhx9T1M5pWHMDszEOt6JnXReY2mUf3WajMACjL5Ze7
r4jMI49TZLA3cWGv3UJKdwn2Kom09/YQpR/tnJ69o7jU02CYZgJYdhyQImA/zXUe
JEh4c6rHJ5UV5GfZN6Ohj94y3fLiXU+Y8hDlDbvss0vzmXD6iyNUlmbdRB3OIU5E
g07fToiOyBQiyYXezSY/nECj++e5jh/lrbU8/d0sXdzAQf6CDhB7+CLYZ/9OmkCh
DWZd0DeLsWcDQz+s3BzLzAo3KBOn1qry8AW8eBYtVKz4ibJ4V/xpDT19qVsi84zn
oG6otSLS+uB4OmwhRJZvxfhW6g1HCJw6gIWpAcIHzK9CNP1ThrX87pNNeSBO03n3
c1UQ6Cr+td0ZuCQVzWZ8KV5s38FUPjbxyQGY4WRejmhf2QB2HKHc3Ug9nYtsseDc
8YS9D3TNJeeLC6/ycEN+
=ReLp
-----END PGP SIGNATURE-----

--oAjj1ZwgLg4oRN9q--
