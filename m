Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3FVRFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 13:05:33 -0400
Received: from ring0.de ([91.143.88.219]:50037 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab3FVRF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 13:05:29 -0400
X-Greylist: delayed 1320 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jun 2013 13:05:29 EDT
X-Spam-Report: * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: overkiz.com]
Date: Sat, 22 Jun 2013 18:43:01 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: =?iso-8859-1?Q?Ga=EBl?= PORTAY <g.portay@overkiz.com>,
        Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
Message-ID: <20130622164300.GB19420@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	=?iso-8859-1?Q?Ga=EBl?= PORTAY <g.portay@overkiz.com>,
	Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	"Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
 <20130622112619.GA8075@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <20130622112619.GA8075@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 22, 2013 at 01:26:20PM +0200, Pavel Machek wrote:
> On Tue 2013-06-18 18:24:23, Ga=EBl PORTAY wrote:
> > Currently, none of available triggers supports playing with the LED bri=
ghtness
> > level.  The cycle trigger provides a way to define custom brightness cy=
cle.
> > For example, it is easy to customize the cycle to mock up the rhythm of=
 human
> > breathing which is a nice cycle to tell the user the system is doing so=
mething.
> >=20
> > This trigger is meant to be usable for waiting an event to happen, for =
example
> > when the system gets ready.  Those cycles may be used to reflect well k=
nown
> > system status (e.g. idle mode, startup...).
> >=20
> > This implementation provides several interfaces:
> >  - to define the cycle itself:
> >    * plot: definition of plot points using plot or rawplot files,
> >            each points defines the brightness level
> >    * interval: constant time interval between each plot point
> >  - to control the cycle:
> >    * repeat: the number of repetition of the whole plot cycle
> >              0 for an infinite loop
> >    * control: used to control the cycle trigger
> >      + "start"/"stop": to start/stop the cycle
> >      + "reset" to clear the cycle counter and the internal plot point i=
ndex
> >      + "pause"/"resume" to pause/resume the cycle
> >=20
> > Signed-off-by: Ga=EBl PORTAY <g.portay@overkiz.com>
>=20
> I'd say this should go to userspace.... and maybe should handle RGB
> leds. ... like the one on n900/HTC dream/....
>=20
> Actually, there's probably some daemon in maemo that already does
> this.

Actually the n900 has hardware support for this. There's a
programmable LED driver on the board, which is called LP5523.

So... I don't think there's a daemon in maemo ;)

-- Sebastian

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRxdQUAAoJENju1/PIO/qazJQP/iNGXTp2DI5isgcYT74JOME0
xJf1N8FeAnHADb6F3gtAY7QF3f5Uh7twY4b4L/mVhufDQ2BxAiSvkcyy2woO0jy6
0zuoNSpUfgQroLrzaH4zJNNRnSBE/cr0vBqxYUerKBhrDf7oPlpwz/dd90C/v3UT
bqFQ2OZvbP/LRBwAjaIDWkbCygMqiFFf9m3n+Od3xj4FTU4ey6VkF4ZvLLhZzYze
mH4KxC85RLeNux9RZn0ohfCJPo8UcYuVQqtFMZC8kMYoTlMJtD9pIUBMtxaUNm7b
JYfXyRYSaGhKWHm+ucX97LEdzPXArWXWaaBFUmkRFTHrJt+7IgLmG+3C4BeHcYYz
4qbVH+NDR7PGAd8RqMRWqSvveOqTaWaTOLe4TGn6fh2UJxeUoAiqQDQT11HJWZ9T
AuhIqefuNwVaJum4kyHMxijVIzGViSKehCLyAgOxYki3RGAnaN4dbTxXq2ogh45D
idvhg3PM3bYtfeUwM91IlIg/nq/lWY5hhnFx+mAa+q0zqBMIGouHwd2oiPMfu904
G5mXpyGCOCdQq0JTFkE9frJ9CKocxKm4mMabScXT62crb5j9tLfWZnmcRIsxXXG0
ZDxx5QMZcCaPigUaLE0duSN3fnhNUY9FkQDeEgzkQb62jPBi34VTKH2zZBNQMjk4
OLychjynwdnAdxce7n5k
=UUZt
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
