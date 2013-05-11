Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3EKOVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 10:21:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60252 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3EKOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 10:21:43 -0400
Date: Sat, 11 May 2013 18:21:32 +0400
From: Mark Brown <broonie@kernel.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130511142132.GA3200@sirena.org.uk>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <518D320C.4010707@elopez.com.ar>
 <fe9e603e-a432-4a29-a195-fd393b875a7e@TX2EHSMHS006.ehs.local>
 <518D411D.9070209@elopez.com.ar>
 <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com>
 <518D7C45.2090602@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JyUo+2rKuw1VKSUr"
Content-Disposition: inline
In-Reply-To: <518D7C45.2090602@codeaurora.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JyUo+2rKuw1VKSUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 10, 2013 at 04:01:25PM -0700, Saravana Kannan wrote:
> On 05/10/2013 03:18 PM, Mike Turquette wrote:

Guys please delete irrelevant context from replies...

> >One way to do it is to introduce a new config option,
> >CONFIG_COMMON_CLK_DEBUG_CONTROL that would expose the controls for
> >every clock in the existing debugfs infrastructure.  The downside to
> >this approach is that it would get abused and ship in millions of
> >Android products using horrible userspace hacks to control clocks.
> >Maybe that's not our problem to solve, maybe it is.

> We already have this for MSM. But I seem to have managed to keep our
> userspace guys away from abusing it. YMMV.

It's much harder when it's in the standard kernel and there's no contact
with some of the users.  I've pushed back pretty strongly on some of
your equivalent stuff for regulators for this reason.

> >I think that Soren wants something with a stable interface that he can
> >use for his Zynq use case.  Regarding that, why not write an actual
> >device driver to do what you want to do from userspace?

> Exposing clock control to userspace production use is a terrible
> idea. A misbehaving userspace can easily kill the system. This is
> not so try for GPIO. So, exposing GPIOs to userspace is relatively
> less of a concern.

Pick the wrong GPIO and you face the same issue.

Note that we do have a UIO framework in place so there is some concept
of doing this sort of thing; that is all about picking specific things
and exposing them (in a somewhat similar fashion to this) rather than a
default available thing though.

--JyUo+2rKuw1VKSUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjlPoAAoJELSic+t+oim9LG0P/3vMdagGvXtdBH8jFRbBncVV
6i98EbfmKwnnOo3OMaOAt/lvjn+XltLyo/LoDdfThEqrgLSaEpcUiyc/HvMb8AG6
4qiRexhVtmfDliUY0JBoCzoX+4u67NcKBjxGtXhix7+FjF+q1/m8h4V/H8rEaSbI
J8pidzDLBdi2BX7wekQ5OWszDNcZfQQ7aCrqfB0KPiFcR92jl6RUpLNzehTXF57a
wxubvXyYNXffwwN+Zc9csYotjct5O6Q8mHXtTWbkFMtCHvxjJl9q43XLSppP2icJ
YT8d0EGjFVMy6sdR/zd+kD1O9ha+sr6/EJTMvPTI3GyrwxKXJS8BA4mucEW5EEzf
gTWgQr3hItCWTlE6Vbljpry9sMPrBONcOSXwOMhrOvnHGizBk/FCLv/RGYWf91zI
FbUrRKGlg9JxlpBJqpZGzPjgwYH7TMgiraMyU+aB1dnYSqeBaBATuZ4P2Iv4HXQ7
7IUrhVLofSgGzAsxUSzVjhpVUg5UtBVcFwIq5XBLthFULAha/TNrowNwd0JNFA28
IzIQ30XmUBqg9NK4I4SBE0FVQ+KIHr34kYmuLgy1mJt/i4753sWZVvugtFEpTKkk
mwruc1RzyyWXablX0130HoBOr3isC3/shb2uJhNpwWG4EqT6nrcY5jdGYV6dL10R
qNsySgJbNttX2D+DWyda
=Wtas
-----END PGP SIGNATURE-----

--JyUo+2rKuw1VKSUr--
