Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaBSB6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:58:11 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:34790 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaBSB6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:58:10 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kay.sievers@vrfy.org,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/2] Fix missing misc nodes
In-Reply-To: Your message of "Tue, 18 Feb 2014 02:27:23 -0300."
             <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1392774991_4248P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Feb 2014 20:56:31 -0500
Message-ID: <9687.1392774991@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1392774991_4248P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Feb 2014 02:27:23 -0300, Lucas De Marchi said:

> These patches are not intended for merging as is... clearly we have at least
> one problem: fram's minor is clashing with logibm's. I don't know what to do
> here.

They both look like obscure devices to me. Are there any architectures where
both devices could conceivably exist on the same system at the same time?
If not, it may not be a problem at all...

--==_Exmh_1392774991_4248P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUwQPTwdmEQWDXROgAQJVlw//ZT5ImZwqwpYgzx//h8ELPQwgAOqCLp/d
K9pAIYKgX1I7ewAx2MppNipqchnajF93lHGIdcVHPxH4Fuwf+tVeUP7TBx6RKm9B
pFpEIMH5HumIgECdbL+ZHFEWq5L5vLENB0kDAJIiWhWXlmxzLR2kVG8XzKJfqZkE
qF4rxqZuRPTpliH2PCRTfMi0lUO7un8izPikJZCA06OqemfchmU+hwIIhdYAd9Ob
2CaPTX6wufixMXtbhYR4ZluqRmrTWD7Wsz1f3QrqbnM9bDLdPOJ65OenszIkltJg
lyesbXgAQkktljCJ+xPTZl+0syKF574RKVXoFtcbEVpHJK99x2e1a2oE8kxZLypO
e9PcYoAH+KRDqSM6xHn7tiVhYrrTk59BZxfOEOrX1LPb9hu4fI7FGAxVh/HkGtPY
JtywNAd0c4JYXgsFIDQQ1+yKMFgTk8TM4qGpQJJVqQXWmJbZ+2B2fsTEXaFmGjyz
Hy8NI190T3n6/FEcmdrLAbI7fdyXg+VNydu2wPzDHSYipfOmKCnAxpg4JaWRRfQm
ZmPYr08IzHRmWshxx6Ce1Q0LVEwc4/sb8/jJ/LCAhsLPp/eSS2k5pJhfNl2zyO1V
onpVMDbkRYF3EPv+qch7nvq9XD2e2pyGnFBJJtesHkiNc+UcxaedHFCRKrvmxS/M
RTFTk0A3hHE=
=GLQa
-----END PGP SIGNATURE-----

--==_Exmh_1392774991_4248P--
