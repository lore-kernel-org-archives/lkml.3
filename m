Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaCLLiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:38:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39024 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaCLLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:37:59 -0400
Date: Wed, 12 Mar 2014 11:37:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, Stewart Smith <stewart@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140312113742.GM28112@sirena.org.uk>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <1394596541.4840.70.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dRVXJ+Hn0i/OWgv8"
Content-Disposition: inline
In-Reply-To: <1394596541.4840.70.camel@pasglop>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the driver-core tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dRVXJ+Hn0i/OWgv8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 02:55:41PM +1100, Benjamin Herrenschmidt wrote:

> How do you suggest we proceed ? I can't add a fix to powerpc-next to use
> the new function since it doesn't exist upstream yet. I would have to
> pull drivers-core-next in which I really don't want to do....

> Can the removal of the function be delayed to -rc1 so we can properly
> do the fixup ? Or do you have the introduction of the new function in
> a topic branch I can pull in without the rest of drivers-core-next ?

The delay would have been my first suggestion - otherwise I'd not be
surprised to see this coming up again.  Perhaps change to tagging the
APIs as deprecated for now (so any futher new users get flagged up)
would help.

--dRVXJ+Hn0i/OWgv8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIEcDAAoJELSic+t+oim9r8sP/3fKFwFMgG/OFEElwquDIgaG
WY3cuOahFM1beenb0utYgrYZj+aWfVGB+/VwVfGJCuq8K450Nuh9vcwH1vrCXW3u
LFrU5vOlaSA634hNhxZYJFvpBkkE0Rb5KDn1ryMuNFLOPTrlxnP12Q9QtFINhD9L
M4PYXOS+Nw1h8ZP530L+MtBaDmtt2FFYt6jWSbBeuJoF2vZxS736LUQVooTTLQKM
2jigyZ4zcZbttnOZ2JrQ1x8LvDzvrb6a2UsceD0gL6aaqJjIVsgHiNbPAKuUrq4e
08T1lzyxS8ykK5S937d6wftTOH/PVh5ygiwT/4uMEZYkUwfQ56ItgQ5Ffa2svcZ4
htRTvG06j39T/C+5zhlmhZP7VGYvyhAKvXP2NzKwdzRVX2kXS41p5rS4H4P+xCKm
SjlueaPnz9MoNPRJjI/GBrqqd9SnBYiIelS9nJgdHP5Q0wkDfySKeS6LqmEMO+bz
nNgQyZfZkixoNjs52vSjPwvu5mCnpyjp3AJMjyeOpwJYd3Oeonjga0xjlMPrioRn
MaRyjlIMIo7y7AoQkCyIrPOoxs/4j400NT6HtZ3lK1hY8WQPCWzd9YYSVfwkabUy
brEIanO9bhkNwk+E1YSQs86eXFRP0Ec76T0yqDci/4loIhySCheb9GOwN6b7Xj9g
vndZFScodadXpLN/7iZw
=hSge
-----END PGP SIGNATURE-----

--dRVXJ+Hn0i/OWgv8--
