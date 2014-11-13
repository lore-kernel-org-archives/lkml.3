Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaKMQRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:17:45 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:44304 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaKMQRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:17:44 -0500
Date: Thu, 13 Nov 2014 17:17:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        gregkh@linux-foundation.org
Subject: Re: [PATCH] ARM: dts: tegra: move serial aliases to per-board
Message-ID: <20141113161738.GB3613@ulmo>
References: <1415738970-7963-1-git-send-email-olof@lixom.net>
 <20141112122017.GC30821@ulmo.nvidia.com>
 <CAOesGMjmVJuaiFZf6msFtsGiQn6TOPatZ7V3p-KfaPqpXnrYmA@mail.gmail.com>
 <20141113112706.GC23422@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <20141113112706.GC23422@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 12:27:07PM +0100, Thierry Reding wrote:
> On Wed, Nov 12, 2014 at 09:07:20AM -0800, Olof Johansson wrote:
> > Hi Thierry,
> >=20
> >=20
> >=20
> > On Wed, Nov 12, 2014 at 4:20 AM, Thierry Reding
> > <thierry.reding@gmail.com> wrote:
> > > On Tue, Nov 11, 2014 at 12:49:30PM -0800, Olof Johansson wrote:
> > >> There are general changes pending to make the /aliases/serial* entri=
es
> > >> number the serial ports on the system. On tegra, so far the ports ha=
ve been
> > >> just numbered dynamically as they are configured so that makes them =
change.
> > >>
> > >> To avoid this, add specific aliases per board to keep the old number=
s. This
> > >> allows us to change the numbering by default on future SoCs while ke=
eping the
> > >> numbering on existing boards.
> > >>
> > >> Signed-off-by: Olof Johansson <olof@lixom.net>
> > >> ---
> > >>
> > >> Stephen/Thierry/Alex, as noticed this week we really should try to g=
et
> > >> this in before the 3.19 merge window so that the global aliases chan=
ge
> > >> can happen there without regression.
> > >>
> > >> If you have more fixes queued up, feel free to add this to the next =
pull
> > >> request. If not, a review and ack would be appreciated.
> > >>
> > >>  arch/arm/boot/dts/tegra114-dalmore.dts        |    1 +
> > >>  arch/arm/boot/dts/tegra114-roth.dts           |    4 ++++
> > >>  arch/arm/boot/dts/tegra114-tn7.dts            |    4 ++++
> > >>  arch/arm/boot/dts/tegra114.dtsi               |    7 -------
> > >>  arch/arm/boot/dts/tegra124-jetson-tk1.dts     |    1 +
> > >>  arch/arm/boot/dts/tegra124-nyan-big.dts       |    1 +
> > >>  arch/arm/boot/dts/tegra124-venice2.dts        |    1 +
> > >>  arch/arm/boot/dts/tegra124.dtsi               |    7 -------
> > >>  arch/arm/boot/dts/tegra20-harmony.dts         |    1 +
> > >>  arch/arm/boot/dts/tegra20-iris-512.dts        |    5 +++++
> > >>  arch/arm/boot/dts/tegra20-medcom-wide.dts     |    4 ++++
> > >>  arch/arm/boot/dts/tegra20-paz00.dts           |    2 ++
> > >>  arch/arm/boot/dts/tegra20-seaboard.dts        |    1 +
> > >>  arch/arm/boot/dts/tegra20-tamonten.dtsi       |    1 +
> > >>  arch/arm/boot/dts/tegra20-trimslice.dts       |    1 +
> > >>  arch/arm/boot/dts/tegra20-ventana.dts         |    1 +
> > >>  arch/arm/boot/dts/tegra20-whistler.dts        |    1 +
> > >>  arch/arm/boot/dts/tegra20.dtsi                |    8 --------
> > >>  arch/arm/boot/dts/tegra30-apalis-eval.dts     |    4 ++++
> > >>  arch/arm/boot/dts/tegra30-beaver.dts          |    1 +
> > >>  arch/arm/boot/dts/tegra30-cardhu.dtsi         |    2 ++
> > >>  arch/arm/boot/dts/tegra30-colibri-eval-v3.dts |    3 +++
> > >>  arch/arm/boot/dts/tegra30.dtsi                |    8 --------
> > >>  23 files changed, 39 insertions(+), 30 deletions(-)
> > >
> > > I have applied this to the for-3.19/dt branch.
> >=20
> > Maybe I wasn't entirely clear -- I was proposing to include this in
> > the next batch of fixes for 3.18 so that the aliases processing code
> > can go in for 3.19. If we hold this until the merge window we run the
> > risk of having largeish parts of the merge window unbisectable (more
> > than if we merge this as part of the next/dt contents).
>=20
> Alex sent out two patches today that should go into 3.18, so let me
> prepare a pull request include those and your patch.

In addition to the three patches I had to pull in a partial version of
Lucas' patch to add the DT labels on Tegra124 that your patch references
in the aliases node.

I've sent out a pull request, let me know if that doesn't match what you
had expected.

Thierry

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZNmiAAoJEN0jrNd/PrOhNMYQAKnmz9+gEbvNMXBt/W7plgWB
Pv3nOwBS7TmzE325fNRHBufjVIOJLNiB+ZxU8aTiRrX0qjXrTZGRbct901FAEAKV
U2pCdgYOVMJtpDAxh495vUOpgYxQHv7sfst+UQAlIFEAEO0WL2tObn8AMU1UxGiF
jKRv8kPYxZuKONPtAOPJqYUiOM8fM7EL+tMGNhn2R2tMLXrrMFrAfErD1jABvc5/
QvGzXJI7+7loUQ3BNaKbFX2F7ncHALJwsoVRREJPi1b+mlCj+CbXc9jokdvn2J6h
4YYDt7ASZolRWU6lC4iljmLRJ6WvjGdAQVtllTEXeUW3VAoG7XPtWBAek9dh0vmQ
zgbKLm8JDrFcfeJdzJY844D1U6X0o+8fJBi50MLwFbwtHsSJg3oPr/sNEyjDHn4M
qlrgRoZDq9WulUHXRxLzdYm3ebdFb2qBhjIn9nFuL0a0YGr7YaiaJkY67h16eFVq
EmncRJAWz3kh5CvF+KsoLc/i0fBZnmH6khPVcxbfedcWjbi4F4bi8MkvgzHMg93j
UlYjC5VyhzxUaeddOZCixHZdDHN5iimPRdXTRqzhaJC4ytPcuh6Wm4m/DJR9iKAr
+7DxB4OTMrGhqvTX/jv5AIlioj8XL/PMUbubRE0STpuTJbeQB0+viqFTAaqBna/W
2rzP7G2nKXKuyaKhT586
=gSy5
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
