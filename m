Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3CEK3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:29:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:55318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3CEK3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:29:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,787,1355126400"; 
   d="asc'?scan'208";a="271218971"
Message-ID: <1362479341.8626.18.camel@jtkirshe-mobl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Date: Tue, 05 Mar 2013 02:29:01 -0800
In-Reply-To: <20130305101437.GD4881@pd.tnic>
References: <20130214143905.GC5700@pd.tnic>
	 <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
	 <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org>
	 <20130215091641.GA14387@pd.tnic> <20130304215056.GG22274@pd.tnic>
	 <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
	 <5135BDF9.3080102@suse.cz> <20130305095821.GC4881@pd.tnic>
	 <1362477768.8626.14.camel@jtkirshe-mobl> <20130305101437.GD4881@pd.tnic>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9ipi4cJUBUF6KiJojLk2"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9ipi4cJUBUF6KiJojLk2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-05 at 11:14 +0100, Borislav Petkov wrote:
>=20
> On Tue, Mar 05, 2013 at 02:02:48AM -0800, Jeff Kirsher wrote:
> > They are in my queue of e1000e patches for net and are being testing
> > currently. I should be able to push them upstream this week.
>=20
> Right, if you'd like me to run them here too, let me know.=20

Any additional testing is very much appreciated, so feel free to test
the patches with what hardware you have.

Thanks!

--=-9ipi4cJUBUF6KiJojLk2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRNcjtAAoJEOVv75VaS+3ORrgQAJ6BCJfiwWM9a/MWmKzpjPSy
jEbqc2EUbpklY9CaD6v7fGsY4OraHMDmJJHlGWs9fbFiukfxRfcxf8OW6h6hFzA3
x9Fbeq5JEx+4F4ZqwzirmRpuMS78dNEz2aPZkpeDdgZ3wRDNawebxYC0jF4ixtnv
PDpAjZXcmFzCOG5Cxau9gLDmnE9Ck1mb2tgcmCFrinRUdoFSF/Z/oQWnLfNqqcNO
rPlVOE8P+5UdVDNp7MLLN7Vu6a6Moewr1CaaEDFIGY1+Y1G8EU3+cY4wGonnVxca
AMejcYztzu5TZFyhliSUcbVVga4gAClKBMCspaHZF4kcNFgfEXrVsj+OElugzAM+
AzICeDfoyeJU9vftxVWSjhbRNDjSxsWzpktxzfSoifw4De4rlujK/Qj9nDlWLY/w
fFlc9ot1lHCR6nbitBXwD1LHkA/ATBXMqElwUYsZ82dq4Vfis99v7tPtvr3PcXPx
9XCHld+DvVSoYPe4HecuGIDjFl29rNgHceL9l1o1Zkk6z5HJwuNXsyGAmSLZio97
QNs8BkgIPeV9CBu+ZtHWFRwvrWjLhqynd83r9J1RPRWwAgvgS1qnhDbNWN037DV9
m20mZ1G8xdFTr6far+NRQx4gzAQ80sb9DM4BXeZHJD0Z9w9VAAv84mUs12a/jDj7
74qEbK+L2pywSrc0IkJi
=McWq
-----END PGP SIGNATURE-----

--=-9ipi4cJUBUF6KiJojLk2--

