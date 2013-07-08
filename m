Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3GHCMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:12:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49892 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3GHCMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:12:30 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org,
        mm-commits@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [merged] memstick-add-support-for-legacy-memorysticks.patch removed from -mm tree
In-Reply-To: Your message of "Mon, 08 Jul 2013 03:41:42 +0300."
             <1373244102.18009.6.camel@maxim-laptop>
From: Valdis.Kletnieks@vt.edu
References: <20121001192920.0D7765C0050@hpza9.eem.corp.google.com>
            <1373244102.18009.6.camel@maxim-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1373249476_4049P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 07 Jul 2013 22:11:16 -0400
Message-ID: <239047.1373249476@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1373249476_4049P
Content-Type: text/plain; charset=us-ascii

On Mon, 08 Jul 2013 03:41:42 +0300, Maxim Levitsky said:

> +/* Debug test to validate free block counts */
> +#ifdef DEBUG
> +static int msb_validate_used_block_bitmap(struct msb_data *msb)
> +{

Is there a reason this should be inside a #ifdef DEBUG with no
easy way to select DEBUG?  Maybe CONFIG_MS_BLOCK_DEBUG similar to
the way other subsystems allow configuring additional debug code?

--==_Exmh_1373249476_4049P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUdofxAdmEQWDXROgAQKH5BAAgAPVeCUS9Fh8FfGdUlyZQTmtAhvpuAgo
iwjnYHVqOOtIdpmyK9Qt0VfvUh16SJDSocbsV6D6H4l0fzu/StaTP6cIQ57bkP57
JUO5/r1Pom+xRwsXp2y2clUoIHHWy8J1n0eS46hUYyItikL58BjJGwrDRRCREosH
ap22vKAjkzJS1kjRqyHhldm4bVfCobQSs9vPiOgQZIZRT4Egcr9dji1r769GeAI1
aBW2f1uLJ2evoGofgksp5/tmdcMukd4s5KsrRApH/BiD9H39E5tPbj2xHeEyova5
ze3DyG3i2LiWYcPHOoD5QCTyP5gmcVvy+kpSe9i71pxj6rDEO4FGSqz1ScWgTuB9
D0rkPoUk50jFaokh4jlrANI2XeXjoqtrzfSbmCD1FdGItXQbpRhaSMkmheRbI1N5
owEC3gcF/oHLPE5D/mIzgsRiWaOXFN5fUtBn4dxE+jawtgWIUgeyyuiWh4JDJbKr
yaKfs5lJf/iYp15xi/2WqaqQePkik/ycMe6zPMspWWzhEwSrkpZoSv9vFzCBdTZ9
Se85lW9BOoDRP1pC3pf/0f9aD4BxuSGDdfHvPSDrs9+X4duDfJgcmMPsWF1AL2FV
P0rLZD9DpljJY+5LEI/L6kvwWuERzfQ2DiXIiy2dyzksupyKn/5bhz2RCTQ4k1Ex
BGFFzYM9ShM=
=TqUt
-----END PGP SIGNATURE-----

--==_Exmh_1373249476_4049P--
