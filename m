Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbaGPQYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:24:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58792 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934509AbaGPQYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:24:09 -0400
Date: Wed, 16 Jul 2014 11:23:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: <will.deacon@arm.com>, <rostedt@goodmis.org>, <mingo@redhat.com>
CC: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Function Profiler broken on today's linux-next
Message-ID: <20140716162328.GJ1365@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I was trying to use Kernel Function Profiler to figure out why my
driver's IRQ handler is taking so much CPU time but to my surprise,
whenever I try to trace anything, I get a "Unable to handle kernel
paging request at virtual address XXXX" error.

Is anybody else seen that or did I screw up my Kernel config ?

cheers

ps: I have tried tracing a few different drivers and they all trigger
the same problem.

--=20
balbi

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxqcAAAoJEIaOsuA1yqREYEUP/2hseJVmSQo2p4wpKj94DRtf
I/z0uliawZcfjHT1dd1pZLB1M7LaVseMyMqBJEh+3EJ+f9dytI1Lhg/AdwfBGnON
1l0+euun8UbU8mPpiX24r8GelKGF4+du7aTLcdEKxRGQKwtWw7Rc34PRHrciH9Xk
+SQNM7IrOea7qP/AKRFrI9IUMkKu/D9USAjt0/OkB2fFkHmRINSSv5ZtGzTvo/6a
+ydBc3k+RrztBkGfuFTHNlNNsZci/Mz+8BmAATWYABSTj7SZiYVcXJp2WKQhOoHC
P9DQa5u1zIySCRPcLmZCaReUQFbbBYQuGacSOaO7toBA698oZG+YdMWfl2e4hWN5
UUxbAdEk1JiXjWrutgr5qMN1LzI+908aQUlk59qpbNiNraJzEDSa+ftwnsy4dJzD
cvCBpxoSSuH1Ba1jrXATR6JwkYGfpPQ2FpK/oXldJLokpRfZihchidrascXMj+QD
WQAa1RycLfH5KSK4vsJoSCJr2YZQDC2c4Kz5la4Pn8dHYwEAYG/gdiFv+9SGV14M
hFWqB7123UTFlX1W3UQmrM6V+Rnesxa7+0w9wE+tw4xLFbuCT/nVRBnPdtMLLC8p
ICk6tr+qWd0Djk5rPFl791ympv2NQ+MwDd/f+g4YcBeYbaugR9Rd/Kd7gVMDjXmY
I2d1nNMjvCvBlD69zjBQ
=fzE5
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--
