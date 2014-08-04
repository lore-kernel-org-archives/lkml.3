Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaHDU15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:27:57 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:52393 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaHDU1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:27:55 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Nick Krause <xerofoify@gmail.com>
Subject: Re: Kernel Debugging Support
In-Reply-To: Your message of "Mon, 04 Aug 2014 19:40:15 -0000."
             <A2CA0424C0A6F04399FB9E1CD98E0304844C4061@US01WEMBX2.internal.synopsys.com>
From: Valdis.Kletnieks@vt.edu
References: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com> <20140804164633.GA28436@xanatos> <A2CA0424C0A6F04399FB9E1CD98E0304844C4028@US01WEMBX2.internal.synopsys.com> <58974.1407180184@turing-police.cc.vt.edu>
            <A2CA0424C0A6F04399FB9E1CD98E0304844C4061@US01WEMBX2.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1407184063_2589P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Aug 2014 16:27:43 -0400
Message-ID: <62334.1407184063@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1407184063_2589P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Aug 2014 19:40:15 -0000, Paul Zimmerman said:

> Ah, you didn't read far enough down the page :)

I'm willing to bet a large pizza with everything but anchovies that
out in the real world, a lot of implementors didn't read further either. :)

> So I have to believe there are a *lot* of systems out there that do support xHCI debug.

Possibly. But enough to make an actual critical mass to motivate somebody
to write code? Or do you get more bang-for-buck by fixing kgdb to support
debugging over Ethernet?


--==_Exmh_1407184063_2589P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU9/svwdmEQWDXROgAQJcIQ//YRd69yEXlQe2puizDj/svak+H1iG/xsh
FjI3I4iV8rQ7Q7N+aI8omwZHukZmB97MmitrcLZ7ouJYnBjDTOyuAekw3vPyRMVh
10qcOtdW3l+YPE+o6k6N8wvYl5FPBI5sSyOYBudUJCkU1nZNtwHrN8NtUW1tCuYm
F92vJT2S7kpSB2/RyufRiU0jqGQlchhCYmmgCR5URF98ztLsIJ76RVh3mS23ZMS9
+WYKdOEpgeN/n+hHzeVpsoYeIPfXd7glnrWAsfLXJgKWEoDvRg354ifn281iyaBJ
XxLtM9wTB5KJzeCP8QW1Xc3LX4NdiWlygfmE47SxxQca4iMxwX5+ohnkVVlCu2se
tjH/w9cQR58GBi+F3fMI9P8hugh+uBrTsP4Nk/0M2PDPapYzAvBOPgG4YpzI76Iz
FmNhNkvoRnV5wc++JyVotlI3zYSsDyiEqEvQ+CixIWbVWnWVsbq977ueJCA5VpZj
Nj9UtB6lE48+r6/oTVEEBFMpmXUKmKBsBFC1upmcHcNGmZTtjxGlo2J6Tck4jxgf
43fdlyfR0nsyrSsngsdPcZ3buaSELI81onMYMXes0DqNuuDVIDk8RoPRWYNqyQAO
Nh0BnLIQTPMeqH8iD9Wb9EINnp/9O5thbrhG1nu8gVMc2LLBPAFNrD9lAZlZ2/X3
OI8e5OZzq6U=
=51w+
-----END PGP SIGNATURE-----

--==_Exmh_1407184063_2589P--
