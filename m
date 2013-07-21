Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3GUXmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 19:42:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56678 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3GUXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 19:42:13 -0400
Date: Mon, 22 Jul 2013 00:41:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Message-ID: <20130721234134.GA9858@sirena.org.uk>
References: <cover.1372211451.git.dvhart@linux.intel.com>
 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
 <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
 <1372398218.9243.29.camel@envy.home>
 <20130704162641.GG27646@sirena.org.uk>
 <CACRpkdbKGti==FTfHm81EkwD++iRfixnXt3kWgBj7CxjM+2znA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+9kyDs7IugQ0lHaC"
Content-Disposition: inline
In-Reply-To: <CACRpkdbKGti==FTfHm81EkwD++iRfixnXt3kWgBj7CxjM+2znA@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+9kyDs7IugQ0lHaC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 20, 2013 at 07:37:54PM +0200, Linus Walleij wrote:
> On Thu, Jul 4, 2013 at 6:26 PM, Mark Brown <broonie@kernel.org> wrote:

> > We should really have a subsystem for this too - the general idea idea
> > of identifying boards, fit options and so on by looking at things like
> > GPIOs or numbers in flash is really common.

> Would it then be a bus following the pattern we chiseled out for
> the soc bus? (Greg, Lee & Arnd architectured this.)

I'd expect it to be a bus, yes.

> There we needed a struct device * on an overarching level to
> tie in the sysfs entries reading out the SoC properties. But
> it would be the same thing with in-kernel accessors for these
> properties.

I'd expect us to end up with devices for the modules doing the mapping.
I'm not sure what the accessors you're thinking about would be, this
should hopefully be transparent to devices sitting on the boards
otherwise it seems like there's not that much point really.

> So it would be the same pattern above with a board bus, in
> DT syntax:

> board {
>      soc {
>      };
> };

I'm not 100% sure what this means, sorry?  If you're saying it'd be
something that sits within the master board for the system (whatever
that happens to be) then yes.

--+9kyDs7IugQ0lHaC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7HGrAAoJELSic+t+oim9hQIP/Rv9nb8MhAOuKfIMJwrtK37c
A4J5XRhfAjN3GKrrivpMHA9FqkLzGhwvAxXa/qMZDT2Ssk5F7MwrtmFcW2taBDnq
GHiYRfwl3iMdIPEPE1t3YqVcFNCdCNxmsuv05uLL0pYuK3pMKOqE+JjMaErv1jPR
dVarY7S+2Ls47H7tP+AtfswHdsMblG5txmaGerHUUpeMga22/xjS+nu4B7G9GPpm
M6gwf6xhjKBXLIIVQbupHvf0Ajb7jNxgcftAIB+fGP0l7IIPC8AWj2JWlj0drLv9
e9Gdd599TpmNGGVQQFeEtxxMnERxUTrvhO+Qdn7+MHFWD7g06v1LiH8MWEj1/FiO
cjbbjf70SOkMPv0c5atetL8IYFCcbjmvzAn5dF+TzUbQ9irVPfpeHypX6ITbBkfC
/x/KcVsE4Zz4WT464LT+NK27hpr7JVCVtcE9vHt2o0ygXd6QIGUmFmPfapvXg0i9
7UrF4rppDWk07oltv6OpMm1chAMnWZidVxwc2Sd2uz++byBJMKb21iD9oTuzQMYy
rOPxcDIZoYk/BhY5mwvv507ZWTf9mo98l2t9c6l5NEXr2kDnq4v0zNl6w8Vy6d+L
yvVKQWzem3qnFRfvoG9t/kNr/zE+1jXkmooJIxFIiMj1iYrsFDMunXT21KWIKDOX
pZpQ9Syi3b3Bu7lw6Qc0
=agOk
-----END PGP SIGNATURE-----

--+9kyDs7IugQ0lHaC--
