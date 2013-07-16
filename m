Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3GPWSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:18:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58903 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3GPWSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:18:05 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: next-20130709 DMAR issues
In-Reply-To: Your message of "Mon, 15 Jul 2013 10:32:17 +0800."
             <51E35F31.1040709@hp.com>
From: Valdis.Kletnieks@vt.edu
References: <29624.1373475702@turing-police.cc.vt.edu> <20130712121419.GA22945@gmail.com> <20130712143122.GF28811@8bytes.org>
            <51E35F31.1040709@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1374012998_1500P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Jul 2013 18:16:38 -0400
Message-ID: <22464.1374012998@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1374012998_1500P
Content-Type: text/plain; charset=us-ascii

On Mon, 15 Jul 2013 10:32:17 +0800, "Li, Zhen-Hua" said:
> I have met a bug with the same error message, its cause was that the bios
> did not allocate RMRR/DRHD(can't remember which one) for the device.

I think I posted a link to that same bug report.  The problem is that
if the BIOS wasn't allocating it before, it isn't allocating it now,
because it's still the same A11 bios that Dell shipped it with.  And now
I'm not sure which is more confusing - that it was OK in -0703 and borked
in -0709, or that between two successive boots of the same -0709 kernel
it cleared itself up....

--==_Exmh_1374012998_1500P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUeXGRgdmEQWDXROgAQK46xAAq6UWeBif7iqGImx5cihgT51RCoh9K8UO
u25hbQt4UHMkUudoOEvBufP0Q/YE4I+lumgci0DtfxuVAUCPrzPUGGrcoqk0J2c6
F5+paQq0EyVdJloC8GrooXK96kBMoH/u/Q76qowGhvivscsWxHtU2sA+5EKOGZsx
yks8qbEK7Wi0erjfGPzS9WwJynaAYtfNqZW70AUlJp608/60PLsPFLLmsk0hZTDn
cYkNfycxxILO07wzb8ZZXgqylfmBh94ill5GEXC2u9u+IVRNitQsEHAqAPfKYMbA
VgLmSCY66eMufKhG/P5PeeR8pgX9qGLW8WlkHroU5Tk4H7Pq4WRUCugAPKlwCHBz
tcqQ9i2ZxmYxQr65spYKYm0dCYRUVeo9c4sozJNp4eRkSoiIleZHhyxqmuGDlWFc
JQ7LmGYlVeOXwWUp2INgjVPL/4N+kk+uvHMAggJpLvC0rYaZ7FgHKqOscIlyNwL9
fosCoQxyuzR03tlzqdWCB+eLs5mFjmNvfiXFbJoX/CI9lJFr+uryvL5oi109o2/I
U3KunvrmbwZoqu4M1EiOxaNuAdh7KFPm0tEq7+ZhVz1mfX5p9qUV5EZNNJM2mPAd
YTjWXHMBzmCJhngIYnWgjJgU5ClXwwzK93HZnkvnJseM1Hyi5N3d7U4kUPDWyvUu
SquLYjyZ0fM=
=B12+
-----END PGP SIGNATURE-----

--==_Exmh_1374012998_1500P--
