Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab3CGUFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:05:42 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:36827 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3CGUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:05:40 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [procfs] BUG: sleeping function called from invalid context at mm/slub.c:925
In-Reply-To: Your message of "Thu, 07 Mar 2013 13:37:00 -0600."
             <5138EC5C.3060002@sgi.com>
From: Valdis.Kletnieks@vt.edu
References: <20130307141224.GA6506@localhost> <3041.1362683738@turing-police.cc.vt.edu>
            <5138EC5C.3060002@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1362686639_1805P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Mar 2013 15:03:59 -0500
Message-ID: <2407.1362686639@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.5138F2B2.00B6,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1362686639_1805P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Mar 2013 13:37:00 -0600, Nathan Zimmer said:

> I believe this should be fixed v5 of my patch.
> http://marc.info/?l=linux-kernel&m=136242660312006&w=2
>
> Alternatively the patch posted by Konstantin to fix up the current
> linux-next.
> http://marc.info/?l=linux-kernel&m=136264090218634&w=2

System boots and lives much longer on next-20130306 with Konstantin's
patch.  If your v5 is equivalent to Konstantin's, feel free to
stick my Tested-By: on it.

Now to figure out why udevd was able to cause a paging issue in
avc_has_perm_noaudit() - it appears totally unrelated to the above issue.

--==_Exmh_1362686639_1805P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUTjyrwdmEQWDXROgAQKrqg/9Gcku/EWHzeMe1nuzOeiGCjb4F8r8ZPpI
iN3dufKfgV/aduTxjquNyZOtVfi0u5akfti2ci3Mpd6TV1ZaPTBU+e3f4Y9zkGMZ
Ys0w6c3qqE4L+D1XO+/HzgrcGTDSZNzbSJaO0LFFy0Og7HAmv0mWC12Bml3ctbLS
GwFTj7qQv006QrRt0VVDdkh9MfK0yS4m7laJ/GH7Vl3XTTr78L978SK91Qge9NLM
rJZEWOuXrEhRfJeu+HvbO0CUUUl3uB+5KGS+T1Gb0h2MDXgL/dH4qXomj90Z35Hz
I3IXfbJhT8c/329i0DxtRLF3IWVCO+qxrXZyUYr+sWw8CCObf9P+XFn3Mv1G/NfM
C0CLvZ9eJ0HfEm+pJz12TZsg7spr6o76GuPeGzMtbgCDnLZt5ogKYG9kjyBdFEVs
chRl6KlR2MjYm+OAOvhOj54bxVCVYZOSSesADsoCPDF+CJsladhVj+HohSmG3r6m
k8UnpSiL1s6Mer72pB+evGsAIVePf0h0xEoASPOCZ2dXVMKIxAbT0jiwfVRgHDl7
l234aeZYmKnj4/eCNQ3hYxzAjqqvKsDA7SwP7f3Z6MHkF+Izu1LuF0qyxrlfeRBy
aKjbOaBQyjHBpVrHlpDOTjsUbQ2ec05WBfCNoT36WP5jEedFJWsA2QfS++90vgGK
RxBwBbw+pOI=
=7m4/
-----END PGP SIGNATURE-----

--==_Exmh_1362686639_1805P--

