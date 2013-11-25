Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3KYOKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:10:12 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:55392 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab3KYOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:10:04 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Mon, 25 Nov 2013 15:10:00 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <201311242041.47075@pali> <20131125140127.GA24125@amd.pavel.ucw.cz>
In-Reply-To: <20131125140127.GA24125@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3057625.DtvM65lKLt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311251510.00987@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3057625.DtvM65lKLt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 25 November 2013 15:01:27 Pavel Machek wrote:
> Where can I get dsme sources?
> 									Pavel

dsme daemon: https://gitorious.org/community-ssu/dsme
dsme thermal plugin: https://gitorious.org/rx51-bme-replacement/dsme-therma=
lobject-surface

dsme thermal plugin is responsible for checking temperature of=20
battery and send it to dsme damon. dsme daemon itself checking=20
temperature limits and do something (e.g reboot device)

in dsme thermal plugin git history you can find both old version=20
(which asking temperature from proprietary nokia bme daemon) and=20
new version which reading temperature from power supply kernel=20
modules.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3057625.DtvM65lKLt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKTWjgACgkQi/DJPQPkQ1LeIACglshbvwK9NC81ueJGSPn5ysm4
AgcAnAjmCa9lwMQXgOt9qzPsfU+v1OFU
=o1Y+
-----END PGP SIGNATURE-----

--nextPart3057625.DtvM65lKLt--
