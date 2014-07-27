Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaG0HIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 03:08:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:62041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaG0HIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 03:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="364882097"
Date: Sun, 27 Jul 2014 02:36:43 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Robert Richter <rric@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        bp@alien8.de, linux@arm.linux.org.uk, ralf@linux-mips.org,
        schwidefsky@de.ibm.com, davem@davemloft.net, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com, cl@linux.com, akpm@linux-foundation.org,
        axboe@kernel.dk, JBottomley@parallels.com, neilb@suse.de,
        christoffer.dall@linaro.org, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RESEND RFC PATCH v1 0/70] Gloabl CPU Hot-plug flag _FROZEN
 Clean up
Message-ID: <20140727063643.GA25432@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <20140725150002.GT4703@rric.localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20140725150002.GT4703@rric.localhost>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 05:00:02PM +0200, Robert Richter wrote:
> > Back to long time ago (about 1.5 years), Thomas began the work
> > for CPU hot-plug, one first thing is CPU hotplug flag cleanup.
> > Paul hoped all the _FROZEN variants of the notifier actions
> > can be removed at that time. Now here it is.
> >=20
> > Patch 1 ~ 69: remove all kinds of XXX_FROZEN usages
> > Patch 70: remove XXX_FROZEN from the kernel thoroughly
>=20
> You might want to update Documentation/ as well.
>=20
Thanks for your reminder. I don't do that intentionally because
1) This is RFC patch and I'm not sure if maintainers agree
to remove XXX_FROZEN thoroughtly
2) I have a little bit hesitation how to describe XXX_FROZEN
status after they are removed.

Anyway, I will do that in formal patch series. Thanks again!

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1J37AAoJEI01n1+kOSLHyx0P/0Gx5YYN6W82Gfl4qe3IH/Ky
Ft+M4oYVQQG2U8qT/CsFZm4mWZIt9E3VM7ZCfCF6KmB745aEmPA7WSLwPWX0EBrz
SyR+SNC28ngBZ6R1NlCF+v4zQSwbP9ApxGaM/RUDXFMxaARX/cNTJgdRCfh4VkH9
i5hz/ds+zZUVFT+DKh2vGywWdETv1KguX/nXKbtGaeDsRaDZJeMMF9kRoZyu1Y7N
wCw7U5w28IP2Awvw2xxA8IdEqxlCYrxXbJWR3nEF9ufFK38YDj557v2BW12S3tSL
KXIEi92WMBONvi+CxkqPMY7l1DFwzlY8/4nBwjiye1IULm4A8cjK8CBo2+cCZSv2
g2cJpq5lkkO92gytKz54TSaRNcaImClRHpNYHiiLMaekO5ggGHKYJK8wqtELf/0/
HxolTcr9oh6HyY4BKt1XHO/W0h6TG21/JMN3GLsbNqEo299XzEQSbn8YeAWTG0dl
jCgpVq88EYUBSqhstjRAPrHOWrBno9e5bgZbSf43+DMRFmp9NDiNwkMjt/EhJFrP
imljDtP72AqgHYTzBXzpK0J2lfj7X1+HIIlli7CK/qCei4Wh8Wr7t4xFLrID6XSs
bFuur8Yh35F58yafcI3ZNVjYI1a1wn3s1GmUOaYlUjaH+woAvoZPlcX+GrujQOLX
kOFkmwpVeDWPvh94C+E7
=/FzA
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
