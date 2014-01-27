Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaA0Tz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:55:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60233 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaA0Tz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:55:56 -0500
Date: Mon, 27 Jan 2014 19:55:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com, rob@landley.net,
        perex@perex.cz, moinejf@free.fr, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140127195545.GZ11841@sirena.org.uk>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
 <1390549386-4702-6-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWAbeGC4mMoqIxdF"
Content-Disposition: inline
In-Reply-To: <1390549386-4702-6-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/7] ASoC: add snd_soc_of_parse_audio_simple_widgets
 for DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uWAbeGC4mMoqIxdF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 03:43:04PM +0800, Xiubo Li wrote:

> The "template-wname" includes: "Mic", "Line", "Hp", "Spk"...

Sorry, this is nitpicking but can we have "HP" or even "Headphone"
instead of "Hp" - otherwise it looks like a typo and people might
correct it.  Similarly "Speaker" might be better as "Spk".

--uWAbeGC4mMoqIxdF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rm9AAoJELSic+t+oim9QoYP/3TihVYe81/s1EGaqDL6aaYy
7CI+FcFXQ+Qf+SWbE4tdGMUO45pQgbHQODfPRvZSyqZyB/LtEtnR0fkyzz2qdJ+h
MpOwRZPQd/i5K2pM4PxR71GmqUQXuN37a+jGAOurXtJDsQJWC/57jdOOzFfqm4mz
ftCKCclloQIsyzzp49JxUoOTBDJdHVe26e2QZPVgigP7qXi/9j9M2QuSjS7IlpS2
C9SW8tSWegxvLuBWq5BI3QLFfWUImDI/s2CJCxKQRnMAjE7GO6QEmg//2pdUCFoV
jRhaaUplDroUzLQSdqs/QLgZXvcvcHBLF9eJWuwAfqa8xRJESYaUSw42HNQjses8
Q1v6cb1mUsTZK6M7We/btiXzjqnkAWkMzwSumNx7NC7SAe662az+FSS+0ZQq/lIn
m8zecdbcKtROMzRr2RjJXGTtjrdHrtSubz5+8IggBRN4hkHfNmnJUtYKJrDtfpaL
CqQMh6d2E/44jxAXPRIsaHhO6PTno8YIJa7A/ieIHpmb3jvGl+Y9syfqAjgjYknM
41icX2DYoVv2Dt0lcDVwISq7T+785rvYEYcFbvQR4/1fDTPwFQ3h0FJHUjF7TBlT
EdFCyT5wIKICyve6+NZxx7WXxFKqT1nHvT8kQLYDa40NIwtA0TbGatb9lWIXw9gM
PaHs70I23degyyeGyx6l
=yugG
-----END PGP SIGNATURE-----

--uWAbeGC4mMoqIxdF--
