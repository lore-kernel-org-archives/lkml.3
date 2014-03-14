Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbaCNRYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:24:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56262 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaCNRYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:24:08 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: ACPICA 20140214 auto-serialize weirds my machine...
In-Reply-To: Your message of "Fri, 14 Mar 2014 17:10:46 +0100."
             <53232A06.9010201@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <14866.1394813101@turing-police.cc.vt.edu>
            <53232A06.9010201@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1394817840_1735P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2014 13:24:00 -0400
Message-ID: <21867.1394817840@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1394817840_1735P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Mar 2014 17:10:46 +0100, "Rafael J. Wysocki" said:

> We have a commit that removes this command line argument already.

Oh, OK..

> But those messages:
>
> >
> > [    0.119344] ACPI: Executed 1 blocks of module-level executable AML code
> > [    0.135282] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)

> shouldn't be there regardless.
>
> I'm going to look at this issue later today.

OK. I've got a 'git bisect' down to about 75 commits already, I'll finish
that up if it will help.  And feel free to toss me a patch if you need
something tested...

--==_Exmh_1394817840_1735P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUyM7MAdmEQWDXROgAQIoWQ/+OjudDjTAFto+R0nbbFuJQm949UtWNLms
0xbkZLEIXH2vxkKMYRGcj4bK411wN2kAGfpX+Yaw5B7Ufe1hEGZ1AAFdJbC0Q/x5
gAW8Rg+0LQ/C2eJ2QgpxEOeMvvb2JFNbZra6sKn+DuYFilGx3+/xaKYaCIM4W74H
MWAphJ9ZfTt3FA7OSOgEXwZB4NbEyKt7gcwYRVNyc5qKmELpqEmBL3+DRI1dj+Oq
aqSxl/q/oyNhAu6APZLs4kwCeLjiJu2S9TvpEzc9BzszwyMWBPZ8UPMekTTAdqh6
cOONGm75K9CKjMl/BV1UKwg4kHvIbgzhrXLpysoQtgj65SHqERsb9Rw9q0Vs7bTS
AX6IUZsIjyomJpSxvJmTyC5kBkT1wLcrlsone1mlhs+6OMkTevO84EIxNFSkttE1
3IOnAD/sBfY3fomrWv6RaND1/NBdxC8NiAL6ueYR3wxxg2HHw5vIetXSv+sQJIcc
aBnHnSvQ4G476H1z5TvC9PVPcLsgz3wpY8a8LF7ImdtSyMOXPuLuANdLcznCCim/
IGBwYX7gxukASfLz5K+kOT662QKKQm6dskGRjV7w0+w2CQYYh7BsE6VbyGQ3YmMz
qeEBwg8vgZ/rpAnWS5t/NZX+8djH7CzYCvQMNxXI0iHkOZ/8jxEdxmrWLvTGNxqu
2Cj6xEz3TmQ=
=xXxi
-----END PGP SIGNATURE-----

--==_Exmh_1394817840_1735P--
