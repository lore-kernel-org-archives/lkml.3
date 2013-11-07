Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3KGUNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:13:50 -0500
Received: from sauhun.de ([89.238.76.85]:57225 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab3KGUNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:13:44 -0500
Date: Thu, 7 Nov 2013 21:13:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH 2/4] i2c: i2c-bcm-kona: Add support for high-speed
 mode
Message-ID: <20131107201332.GA7119@katana>
References: <1381960909-1735-1-git-send-email-tim.kryger@linaro.org>
 <1381960909-1735-3-git-send-email-tim.kryger@linaro.org>
 <20131101130835.GC6734@katana>
 <CAAYSxhrrkSvOJpYPz7txVsot1you3fFzkXJ6fqaS4OgRM0Z2gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <CAAYSxhrrkSvOJpYPz7txVsot1you3fFzkXJ6fqaS4OgRM0Z2gA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> While the bus speed property is really a configuration parameter (and
> not a true description of of the hardware) it seems improper to put
> driver specific details into the binding document.

OK. Then please change the error message for unsupported bus speeds to
contain the supported ones. I don't think it is good practice to force
users to look into the sourcecode to find this information.

Regards,

   Wolfram


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSe/RsAAoJEBQN5MwUoCm27S8P/R9Qb0Ohol9Kl7vSPYcZ1kNZ
+I5P1jmHZkVFSzuJT+k8Brm40krLMmTOP+r9yVvhFVVF7kc9Ul0/UNOjPCJITxTf
xd6xl3UAkBc65Wc27Ox584QOVRlIKAZ+rTkCXGXNYnKQi4asRSr076dX4Cy+sfxV
bqTPMk1p8qFO8d9iUTe9DYhMAktzDXmSrC9eIKB11TB6YA1k0txyjpGNnM1oxGTQ
D9DPk0ZBpSH9bBdMOxH+QZeukcLECrsjSm283+BmjZlulWYDe/lir+T8w5FHQ6A+
LvUmLPhX+W3dBMR0dVDfaPHiaft75qQGIgUSu8b9XitDxHchNfPSKt6USKShnES0
s80MKbIh/U/9zreBXqZOPTap3318Bp7D3rqoZMN8q53uPdyjYoGyEXXEHlX25IKx
7kc/lOZ/3tlLs760Kt0W52CP9M7iha7J6CS8AEKLewsMw2/KswMft7CTJM6vbftt
Uw8fHuv1XXRa90pHPp+coPR+VZvtJMr4wWnvdbESpjxF2caGvwnaE1X5rO9qhjgD
ROyPw7gx6625Rn2w1WzFlMyPQQxfTnjDGdlsFlRhoKuDRT685Yw3LeGixP8GF2i0
yEXhsRijtasrvvwqemgqvjZ5pXNpt3nijg1sfTW2Q3juXW7/KBtHGxfXzEPqDk81
0e7TKB+70pUIYT0KtcG9
=s0Qd
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
