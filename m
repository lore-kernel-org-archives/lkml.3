Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3A0JpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 04:45:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39252 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786Ab3A0JpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 04:45:08 -0500
Date: Sun, 27 Jan 2013 17:44:34 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 06/10] mfd: arizona: Allow customisation of microphone
 detection levels
Message-ID: <20130127094425.GB32135@opensource.wolfsonmicro.com>
References: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1359259652-8565-6-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <1359259652-8565-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 27, 2013 at 12:07:28PM +0800, Mark Brown wrote:
> The microphone detection levels for Arizona parts can be customised.
> Allow this to be done via platform data, the values chosen will depend
> on the system design and determined in discussion with Wolfson.

Hrm, actually - since this isn't applied and I have a more flexible
version to follow shortly (integrated into extcon rather than MFD) can
you please not apply this?  I had forgotten it was still waiting for
merge.

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBPbQAAoJELSic+t+oim9ocQP/j0Gu+3zmSOZbJTdWW2Gqo1N
Q01S5vg4/b2lX76Akpr4WK1h96vqDHiDHj6DG583aaE1DoEAHQq+Fkk1Fk0KIdVn
+iuVMJkchkg3Jo3oUMD1Lk5rVOhwy+yNZWlZfPUhIDkEwclhoEaqQA+ABb7Oi76S
SACuBRC4cEwOEfffCvQLgXP6Z9z7i/vHWaqHirAj3QnKlWU+FtRPkvw2hjjr+Ilg
iZtB9Rlg9VeWpxgndx+feuaplJQ9aXMZA4rqEH50zpMu6JS0P0lN/2qe4Cbs29Im
fw5JQkUXPHb9a5qqiQvZ/XrNNR+mN2iVzibEv0wCUIsq48w0FOvGlKPZwAtOi1UD
c/Ls9ziYzKpivoIuk2VfwSuo2W78bvWnsQSNlCDXSUIfGY8YJXyGQBbinpHqFs3c
tcCBvjnUFj99Q6STJpvvwBi73PafL1zjDp2N9i39GoAvTSvrw2YdRMh7sMnkaeKt
0yCX0BBzn3J1rxZVnSRU/CJx776WPHyCpoyrlgdOeoyp1w8wl8Ppsa/G5zfWLpBJ
Hf+xl200cjvDzA7qQQyv+hdQ4Gg6TTB5gqnTlw1CgmqCBzLm/qwmZlL+BCuzr1SX
B76Hs2a2abm8Zws+Rk4AidlpZggMX9yxYQa4Jbo0EhxOfHUFKUq3AWn5Dax5DU0Z
3xgvf1ywXufiAt1ZHNsj
=EMhM
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
