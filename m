Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaE1Rtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:49:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE1Rtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:49:35 -0400
Date: Wed, 28 May 2014 19:49:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528174927.GY30445@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
 <20140528165144.GK29957@tassilo.jf.intel.com>
 <CABPqkBRBB0feNceYJCU43efOfyQqAugzaWzz04mr7mzEoJGhsw@mail.gmail.com>
 <20140528171243.GL29957@tassilo.jf.intel.com>
 <20140528171957.GW30445@twins.programming.kicks-ass.net>
 <20140528174545.GN29957@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PlWN2or5MzbGPm4Y"
Content-Disposition: inline
In-Reply-To: <20140528174545.GN29957@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PlWN2or5MzbGPm4Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 10:45:45AM -0700, Andi Kleen wrote:
> > So the window is fairly large for another to slip in, esp if you have a
> > fast (say inst-ret) and a slow (say br-misp) event.
>=20
> yes, but unless you have really small periods it's still very unlikely
> that they synchronize, so it will only happen very rarely.  And the
> rare cases won't affect the statistics very much.

Sure, but it might be an information leak... Not sure how severe these
are, but again.. it blows to have to worry about this when it would've
been 'trivial' to actually fix.

--PlWN2or5MzbGPm4Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThiGnAAoJEHZH4aRLwOS6MZIP/08dAfAbfRAas5XC15Tkn4M3
hRJFnMwZYZNAuNWy7CXKtRrSWNmt7xdy0tUtQeQNFKTKZfY5FE0ET8Mg37Vqw74N
ovlPY/o+bCXoFD1JKBA/w0ScBmI1mNma5Egs5WW60ZWz0GuU9b4OBjT1+Lyqat1L
ty/9nFQH/1MooYVudZkXhg6TpptkIOMI4oDyNwuVcwyez48/FaQ+dETCyM6S/aCV
nsvM7LZvXcRu5xAwx3GQQVt8ms7vETHmYvWw0D1sSI/w/QQp13QBZMIfRB8pp3GD
cVPuWiG4qTi2OPgu8CABHGZuWrJtMdcOtheVm/8YVwDvvHBU4btDbxEhnPLljAtw
xqvG3Q60n32j9vwKjuXacSvyj6jJuF4wj8uchhy7Yviu4Zee9zC7D+7LwgEuUXqZ
septmtV6MqyTY9NgrpDvCyTZemWtbVcpavnv6gmzEsAlUaZcby/k6ELUvoh55BOF
P78YxqX9/tNTbiZWU/mitp3s/k4JIiH+loINIOPgMOEu/prA2nGFfQF+HS8xdwAQ
Vm3esLVEmzgZ62QQ0NL6ZOE9sRllwRSx0XYnWJo6Md/r8Cqav88SxzRuWkk3dzoT
h6+bE8/BPULEoQD+YScir0qLzSLIWDaxBkuoO15leKFrhBK8YKPoTVSDLGxJjplW
rpllDss3o6nxK3h0bhbn
=hAM2
-----END PGP SIGNATURE-----

--PlWN2or5MzbGPm4Y--
