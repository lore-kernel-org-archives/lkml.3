Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935235Ab3BTMOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:14:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36022 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934203Ab3BTMOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:14:45 -0500
Date: Wed, 20 Feb 2013 12:14:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Query]: Regmap v3.8: Compilation Warning: regmap_read_debugfs()
Message-ID: <20130220121441.GB2726@opensource.wolfsonmicro.com>
References: <CAKohpomdJBWrwiNx8T2-vT-b5wponNCMw_PGDMAULgoWidbOZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <CAKohpomdJBWrwiNx8T2-vT-b5wponNCMw_PGDMAULgoWidbOZQ@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 01:23:09PM +0530, Viresh Kumar wrote:

> I am unable to understand why this warning is coming and that too on
> line 180 (as that doesn't use this variable). I can't see how this variable is
> used uninitialized.

The compiler isn't as smart about code flow analysis as it thinks it is,
the code is safe.  There's a patch going to Linus this merge window
which shuts up the warning.

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJL4nAAoJELSic+t+oim9WbgP+wadSYltpEHLJXsedLVi/xFN
qYSoQDcLdQ2dY9hTRgeypd059Tfo4TttRo42VdoUusQQtvzX1RUwQdYUxzBGVsQI
NVqu9jMDemO3hnElAQ5nxCVSy/H+zk6ldK+y4Mu7FOHi6VMwgsZ+ZCc5hZ+GLbnT
yGggdp6OOh1poT4QoK2UW6jJmN3lyeeKblOmRg7O4FkeacIoXA0bTqKVDrK/W2Nu
iq6DYOS+lP9fWzwQCfOXKm+Kbcxl7TQBStsEoBWPdysBwGalsX2hWGkYcg91eELX
rs2VvodRTkLk3t9R+TVwlSDjy21iWy4kco3MuUeSAYbFJlJuaTOE2WpnXfPgpy2m
GOryHc++vycm8EVEWQ3CU2k9SwmilxL9N4+4dyo6Mc3Jt0MIAU1a5NMILmf2SfjW
gfSy+txgGQiooHmokT/++XJ5t/9SMtRDkO05pRRqpcOAOJ/1BOZxsMQWQAHTJzjO
7kVwFiOk6nM7j3hciDptYlqP4ouQ6qtd89ABPbj4AdeDWFNjhldMZ5RHWJxBzPY9
1RfXbVm/ohl2Bai1j1OKpO26cKAg1C1ZjlufZRLbEDF6OJbuJuMy5a6d5EQknaUp
RY5OYAaQm9nswf+n+oS4Q0FATcHQXw7GC4iXtkc6gjDyzCwmeWBSu7G0I/ItwJ6q
MRoW+uQLdcGRdg9qdDHH
=h8qT
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
