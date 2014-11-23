Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaKWQWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:22:19 -0500
Received: from sauhun.de ([89.238.76.85]:43215 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaKWQWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:22:16 -0500
Date: Sun, 23 Nov 2014 17:23:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v8 6/8] OF: i2c: Add OF notifier handler
Message-ID: <20141123162326.GB1303@katana>
References: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1414528565-10907-7-git-send-email-pantelis.antoniou@konsulko.com>
 <20141121015335.99BF2C413E8@trevor.secretlab.ca>
 <546E9D75.3000208@roeck-us.net>
 <20141121150837.20DC4C40D85@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <20141121150837.20DC4C40D85@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I picked up the patch into my tree and made the above changes because
> they're pretty trivial. If Wolfram is okay with it then I can take the
> whole series through my tree. Otherwise I'll put the of_reconfig_* empty
> stubs into a separate branch that he and broonie can both pull.

With your fix applied and in case of targetting 3.19:

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>


--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcgn+AAoJEBQN5MwUoCm2tIAP/RULnWQjdzIKKiwQUBYw60fF
58Ha7WPDM07X36HWiS+bW/D/ZoWguLRqBC3XdfFLk8vqLSw511108hzG8saQbTGQ
Xt9+BGMimATszp0MIke3Qnv+rq0v56zGjq15jtgJJaf+kAZYRZiat4m3adeYpMtJ
2sWzGf0e1uCf3nVIzr/gAMUPimCFdaPJoKLDldL0lLAk+XKwK68dprDdk+3Hkd9y
SdmoSb4gdXzEviG2IvvYCL7xCrLsIRC1pnINbA5j7z7TKKv3fMASkvr8MNZUa99t
o7qiTKkrFeaJE1nIJFKhB/2B/tUzvULlxOh/8PVyd1AJB9JggiLP9kJx3cpE4QaA
uKhVnaNOgPWVDIBm7YBlbHZQovAAqxI3VISwxkib2iFYw+QApo5XiExaME2Pt1jr
QL/73AJvUxN+wefoNGvv3U7D+7Cfx98YH/tmnJs/oc3wBhE8SChQShK++RMJxd22
zmVc+A6uMhexkxx2vtvd4S6n8njcMMMCD8VRvVlLZVMh76sie1GsPqLW7hFKj/JE
hbWb6GIx+7giqaHR045YIj7+kaI64MxciBo4soaoaIe0CpU9abJfeEy/g0/LmLBQ
FDTiGwUPE8T/OhZjO69OaX/6WxQ18XasJFO78bAtRCw+ei6yuc/GnH5YZIB4zStO
v5aKcKtyr217hWj9k1TK
=PwMc
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
