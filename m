Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3FQEju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:39:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34780 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3FQEjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:39:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [uclinux-dist-devel] [PATCH 01/11] cpufreq: blackfin: enable driver for CONFIG_BFIN_CPU_FREQ
Date: Mon, 17 Jun 2013 00:39:49 -0400
User-Agent: KMail/1.13.7 (Linux/3.8.3; KDE/4.6.5; x86_64; ; )
Cc: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, patches@linaro.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arvind.chauhan@arm.com,
        charles.garcia-tobin@arm.com
References: <cover.1371022830.git.viresh.kumar@linaro.org> <257a5d42e71bcec9fa9c8d09e1ad2c781db7c083.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <257a5d42e71bcec9fa9c8d09e1ad2c781db7c083.1371022830.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6294892.iTiYXKjeEt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201306170039.53657.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6294892.iTiYXKjeEt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Wednesday 12 June 2013 04:15:08 Viresh Kumar wrote:
> By mistake blackfin's cpufreq driver is enabled when CONFIG_BLACKFIN was
> present, whereas it should have been enabled only when CONFIG_BFIN_CPU_FREQ
> is present.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart6294892.iTiYXKjeEt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRvpMZAAoJEEFjO5/oN/WBbVQP+QGgKzpUkDvr/gsrjSiocnck
uCaumylrvo6mngMe4wrgFWDge19/v4CLwOrNRI9QbVE4Wyy4u+dw93+il1tltrmu
PpA0SyB1kL91kFCDr4gknnsqS39VotWY4CHXgxYOYBeg9Xrx8zO1thkhLtxNZTrU
PB+FlEUQsCUnLkhQpjAtT6jr6KRQen9w8i0s7NECku+UOBwWBIvMFN4pMkngiMUV
kShZ6TUgTLo3Z2JarMnrPwqvKioT5ha7gNHpqD75BLCaLmC7kv7I3c1+l43L2l6f
VAVxohMxGJr+QupBmS0AicnO0HuWGebT0Zb3hb5XCwNG/SE9XZ5K0K5es7ItSRAY
28MBy9gbcdgO+0YoycvwqrrThH/JTxuV8PaoAgwYDBNVRiJeGjgwYwMrtl+1eFH9
2Zv4OJLbQtT97SiZutTyDN83nVwlCDMlf7sI6mPo+i/yuNThrXEnOUvDHOlYUUWc
8+m++JzgWYeDkblE4yiqvZEDmbA0CDuePsmwElvCYrPQsqGZ0Z+39rT0FX71/evS
yRRNAPQy3dHSezhT1EMSZD5mqecm08DALNoN8qfEmwJWIpIsljjwrMpGIZbWGjHA
iuRSB8Uch9Jk3Ln9AcJXtY8Klp7rAFoxLp/KPeUfPsAGjOfspoe9GldLj407P1uu
z/MxN5Vqk57vJSf/4JG2
=sp2j
-----END PGP SIGNATURE-----

--nextPart6294892.iTiYXKjeEt--
