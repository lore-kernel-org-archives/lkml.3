Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbaGAQyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:54:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51535 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbaGAQyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:54:06 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: next-20140640 - fatal crash at boot time in sound drivers...
In-Reply-To: Your message of "Tue, 01 Jul 2014 11:18:15 +0200."
             <s5hlhsd8mjs.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <11205.1404146754@turing-police.cc.vt.edu>
            <s5hlhsd8mjs.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1404233632_3099P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 01 Jul 2014 12:53:52 -0400
Message-ID: <6331.1404233632@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1404233632_3099P
Content-Type: text/plain; charset=us-ascii

On Tue, 01 Jul 2014 11:18:15 +0200, Takashi Iwai said:
> At Mon, 30 Jun 2014 12:45:54 -0400, Valdis Kletnieks wrote:
> >
> > Seeing this on a Dell Latitude E6530 - kernel lives for just a few
> > seconds before committing hari-kiri trying to initialize the sound chipset.
>
> The bug has been fixed yesterday, so today's next tree should work.
> Let me know if you still see the issue.

Confirming that next-20140701 boots without this issue, thanks...

--==_Exmh_1404233632_3099P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU7LnoAdmEQWDXROgAQIOyRAAmt1eGiXxz276ZZaHFBUgHj7nbO3XBzES
i1TzXCllIPauSS7IECt0j8tI1QH5ATyDNGiBnEHtLNwPjXnMMdklFKpzLYXJk/uS
oOyeZ24KyKgiT3sLMu4P4ggDZVCrL/diDQTCbdxtub5Jsf9O/X4qVRnI5gRXX0Z9
9UYuPVtqnxaE9JM75bGi3jmBqenB1uB2Fl3Yce+PmQtCM8w1p01sWHpgBqXneUgt
fCHq+oJItAwcfwt8aBfbWKVM/fAF/rET2hkfoTF47cIp2pJDtBpZ10uuV/2WVYFU
f1zwyb84uF95Wgz1w1jCgx1MIZ9+pwGS7JGiMj+tNZCvlnxaKF8Phv6WhwXxwdfr
KComtFvbtitFilAuMRn2FjQs7iK/zjz3O9vwu9yToyIJ1SqaS+C8U3SNLS/x2oso
Jc5VFfcWblF4Q7pfJ3knkPJ+zS6rcqsWEKFpqElngZrKHdKWhxaTfWmhV3ErDeik
IvEX/mSxafliMbr+1Qq4Tl2APd8TjOA9AHa3PRWf+37a+ivjJ/VrltjBLK4O2+5x
n8BY/HexDdAYGb9vScXFPeMI5e4NW7bdu/0VzYPwHBUV6/5KXQXGMdEc5raaoiOX
JpZKUe+UqS4l3j6o+9UvnbXDTiCaxZLOSkUMhbiPjkaLM3TIlj31VTWFgzq8NaCR
I7vqfIPH99M=
=iDQ4
-----END PGP SIGNATURE-----

--==_Exmh_1404233632_3099P--
