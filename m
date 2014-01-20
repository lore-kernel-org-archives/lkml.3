Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaATSZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:25:41 -0500
Received: from ring0.de ([91.143.88.219]:39099 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaATSZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:25:37 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 20 Jan 2014 19:25:33 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140120182532.GB25920@earth.universe>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120164926.GB23051@amd.pavel.ucw.cz>
 <20140120171010.GB29971@arm.com>
 <20140120175431.GB25439@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <20140120175431.GB25439@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2014 at 06:54:32PM +0100, Pavel Machek wrote:
> On Mon 2014-01-20 17:10:29, Catalin Marinas wrote:
> > On Mon, Jan 20, 2014 at 04:49:26PM +0000, Pavel Machek wrote:
> > > > To save energy, the higher frequencies should be avoided and only u=
sed
> > > > when the application performance requirements can not be satisfied
> > > > otherwise (e.g. spread tasks across more cpus if possible).
> > >=20
> > > I argue this is untrue for any task where user waits for its
> > > completion with screen on. (And that's quite important subset).
> > >=20
> > > Lets take Nokia n900 as an example.=20
> > >=20
> > > (source http://wiki.maemo.org/N900_Hardware_Power_Consumption)
> > >=20
> > > Sleeping CPU: 2mA
> > > Screen on: 230mA
> > > CPU loaded: 250mA
> > >=20
> > > Now, lets believe your numbers and pretend system can operate at 33%
> > > of speed with 11% power consumption.
> > >=20
> > > Lets take task that takes 10 seconds on max frequency:
> > >=20
> > >       ~ 10s * 470mA     	     	    =3D 4700mAs
> > >=20
> > > You suggest running at 33% speed, instead; that means 30 seconds on
> > > low requency.
> > >=20
> > > CPU on low: 25mA (assumed).
> > >=20
> > >      ~ 30s * 255mA			    =3D 7650mAs
> > >=20
> > > Hmm. So race to idle is good thing on Intel machines, and it is good
> > > thing on ARM design I have access to.
> >=20
> > Race to idle doesn't mean that the screen goes off as well. Let's say
> > the screen stays on for 1 min and the CPU needs to be running for 10s
> > over this minute, in the first case you have:
>=20
> No, it does not. I just assumed user is continuing to use his
> machine. Obviously, waiting 60 seconds with screen on will make the
> difference look smaller. But your solution still means user has to
> wait longer _and_ you consume more battery doing so.
>=20
> And this is for any task where user waits for result with screen
> on. Like rendering a webpage. Like opening settings screen. Like
> installing application.
>=20
> There are not too many background tasks on a cellphone.
>=20
> But hey, maybe you are right and running at lowest possible frequency
> is right. Please provide concrete numbers like I did.

So what about using the display status information for power
management? Basically always using the lowest frequency should be ok
on phones if the display is disabled?

-- Sebastian

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS3WocAAoJENju1/PIO/qaxdgP+wT2BDChksSS/TwEq+Wkkmua
ba0ateUXS9brlPY0Ng6Oi2CtD+1QVTRTPEu6PpVWiaktiNY/xEasXfLx+WSJvUi9
xISylJstI0DC55vPDXD/9HtEsXUKennIFjcuosgEFtymtVfSmXvs05yAsCBlvvvx
ExebyR+zMHjLVkk8C1Ogt5XgYENodx7MT2LlbHTEAw9HooO61jLoE4eZYoQwzZou
ET/e8nu2F2YjtN2fPrRR8Og9lMX2CBljFdTwa98YGnNF0GaYxxWDjT+0LNp2SYKk
OePRuhH3DejgXd5M0MnFLU6oAWEsd+LsiIYN8Z9cXUdCQeWnpmcf5jHX4jjnLDOd
blyGCz97c6QcH0YstrZjsgc1YOhW0VXLe+jZUvQk4VJ7J5Su99tUs+H3KpX9UYZX
8MhmEWqYPCLSTwqbP2hIkUyx11lJcvi6qjaXWnEyZBvlTfynhOtve0H7JXVwTid9
1wbRS3U0AcWqWrhMdBDTG0qC9+zXrqSa55Jv4mFS6gQXfiordWhrDqP2zmC4aS04
SB++ZWQ/pRjhn4W7plhTlzQAeiYsaZvnxMDhdmBZIoYa25h81F8M/48xL9D3pwZt
9JfWuoT8DSsKVXk9hMinfHT2UNQFJhDnyspD5iACElkgU0YB55liQ7H2v+pHTG04
/J4BJdIZ8mpeyfQ8J4wK
=9fp1
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
