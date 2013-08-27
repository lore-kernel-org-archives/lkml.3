Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3H0Fj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 01:39:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48079 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab3H0FjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 01:39:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Joe Perches <joe@perches.com>
Subject: Re: [trivial PATCH] treewide: Fix printks with 0x%#
Date: Tue, 27 Aug 2013 01:39:25 -0400
User-Agent: KMail/1.13.7 (Linux/3.10.6; KDE/4.6.5; x86_64; ; )
Cc: Jiri Kosina <trivial@kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniele Venzano <venza@brownhat.org>, Andi Kleen <andi@firstfloor.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        "alsa-devel" <alsa-devel@alsa-project.org>
References: <1374778405.1957.21.camel@joe-AO722>
In-Reply-To: <1374778405.1957.21.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2301473.EoAcj9NbxQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308270139.29838.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2301473.EoAcj9NbxQ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Thursday 25 July 2013 14:53:25 Joe Perches wrote:
> Using 0x%# emits 0x0x.  Only one is necessary.

sounds like a job for checkpatch.pl :)
-mike

--nextPart2301473.EoAcj9NbxQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJSHDuRAAoJEEFjO5/oN/WB9eAP/17Fsge8+iHzu8tiC05a4O7x
rFgbaVSjlB4OEKMva3jKJPcdIwNjokS0rW6HfCLVVx9AbJC+Y+O21B95DCfD8ZCG
7LECoepLtCh/pjtblxB9vevhjFVhqLtxVB68+kRziZ659QJZn93TWWO6eYa1hYlF
NcqeX4cn5irE1eFLb5ghoSdPtGD0PIA4a/3WKoYg62wcx4xSR8UKzdTRTke7Zsfz
Uscb1S6+XTTp7+hYGyDBUHp60DSmnN4m6MG6XMZKDGxAv2FfpF6h1tBTJu/ubpVg
bGin+f0QRfVnIOMIzx5T9crH0JCfCmthnaFhs9+aEnqoPEQVTtqY577mV+k9tPY9
ygB77cIfcePVENVYoOOLn5CjxQjZ9oaRG0acnBNWepoFS5ywKW4xO1H5k2LPY9o3
Ivq0Dk0Elt3LVLhMtp4IH1GSrFlr9Rsc5+OU60suo9MlHFHobdt3YewUse8BUdQY
4JqLrAKsvc6OYI/iALy72b7ecPyKi0hcfojOICoDzMd1m7v2AEJ19OIft2RtGij+
b3WP2GvURB3lYst9eUUSn6Ga9QGtt/nbDtm+aHzPkBn1Y+KxoWJGL/rDtBPQhON6
AfXoHYKx6BoB0zoOqdXa//MKQ33YTMuehll3Jk0wdg0PLjyO1zPjCSSHB+q1ur8t
aqPDySYINMZvN6N/MT3N
=EMNA
-----END PGP SIGNATURE-----

--nextPart2301473.EoAcj9NbxQ--
