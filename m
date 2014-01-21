Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaAUUbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:31:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57736 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaAUUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:31:44 -0500
Date: Tue, 21 Jan 2014 20:31:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140121203137.GY17314@sirena.org.uk>
References: <20131125174037.GR14725@sirena.org.uk>
 <CA+55aFwPcr8TYpLUg5NP9x3RGCv4+U7vz-nNH6Br5ku3MDwaDw@mail.gmail.com>
 <20131126003919.GT14725@sirena.org.uk>
 <CA+55aFxX3odNLBt1L6iAPGybekioqaW3SREmXywd_jnz_tDBeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f4rLERh+hIhvDLQR"
Content-Disposition: inline
In-Reply-To: <CA+55aFxX3odNLBt1L6iAPGybekioqaW3SREmXywd_jnz_tDBeQ@mail.gmail.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regulator updates for v3.13-rc1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f4rLERh+hIhvDLQR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2014 at 11:16:57AM -0800, Linus Torvalds wrote:
> On Mon, Nov 25, 2013 at 4:39 PM, Mark Brown <broonie@kernel.org> wrote:

> > If you're OK with octopus merges for things like this I'll definitely
> > take another look at using them, the enormous stack of merge commits
> > always looks noisy to me in the logs and pull requests and for things
> > like driver updates there's unlikely to be much doubt about which branch
> > it was if there's a problem.

> Christ. When you start doing octopus merges, you don't do it by half
> measures, do you?

:)  It seems Takashi was right then.

> That kind of merge either needs to be split up, or gitk needs to be
> made better about visualizing it, because it ends up being *so* wide
> that the history is hard to read.

> I think you'll find that having that many parents also breaks old
> versions of git.

> Anyway, I'd suggest you try to limit octopus merges to ~15 parents or
> less to make the visualization tools not go crazy.  Maybe aim for just
> 10 or so in most cases.

Ah, I'd not noticed that one - I tend to find gitk output pretty hard to
work with at the best of times once you hit lots of merges in a short
time unless I limit it to particular subsets of code and once there's
filtering it seems to cope well with both approaches (modulo the detail
on the final merge commit).  Long lived branches that go from -rc1 to
the next merge window aren't at all friendly to visualisation tools.

I can easily limit it, anyway.  Or another option would be to have a
branch which collects the merges incrementally rather than respining
them all the time (but has no development itself) - I *think* that may
be a bit more friendly to visualisation tools if done right but I seem
to recall that such integration only branches were frowned upon?

--f4rLERh+hIhvDLQR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3tkmAAoJELSic+t+oim9DosP/0JfCrz3LfpRda+03CSpi+eZ
wl5EGopYX0hgCEQlQ9s51GBnfMsxu7Jsf0CIzv71GW/G1dJIPhAyFChFtUWQ2cUA
O3MGFndPf4p+vdbs6c7rFmDcqWLoWSE1bHAkIs1l4cdTuoa5Co/4dJzqMSm8p4Kn
CFKgzg7KCxD+h4iPwBop+NmzWTGDE5+MTnfiJ8w9MjKPw9iht6uz9bXxBLHXBWv6
6B1v+ngrCqG2ktSEtugoOGuj4gYbYhwXgwnnaLPhP7ysVTBS6Y3jSm2mrIyEvjeJ
dZQ7QSXVrtTticyybYtg0sZKqwbMGGCJ0sQ+g5jM50XsapHfjhL4yPQ2rx15wND6
ml9Hnja4yof1X3Qat7+B6vVkJrgTW442SYzq+kInW4qbiMxMz7MMYUZC/9xJeJvV
FJClkbi6QInbORt3xUUSWGhgZNqA6ZWp5Caq3osRkoqkDYw4ge9WDRPYwvhknvOv
wIEXfi15aiq+62ALxM5OblXn/jazyi9aQeUpEAQqQbezNw/QnvF9vgocIxhJ0qnX
/JcruELujH7UGMI2sKDM281ZraQ3VAThPkwt1LEyfELmrtqUe2LA4BPNF7/wsI2g
S5c5OrXws1ASk96i2LmO05+Tth/ikXBaeDUx2XXJrHHhnnbnkXNQLPFVFE863/n1
MUVsPc+qu5phqORd+XYq
=VVc+
-----END PGP SIGNATURE-----

--f4rLERh+hIhvDLQR--
