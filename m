Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaEATGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:06:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54412 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaEATGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:06:37 -0400
Date: Thu, 1 May 2014 12:05:40 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olof@lixom.net>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Message-ID: <20140501190540.GY3245@sirena.org.uk>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
 <1397689950-1568-5-git-send-email-dianders@chromium.org>
 <20140423115102.GO21613@lee--X1>
 <CAD=FV=WN4hVibiK_8+mpNfO7UQnd35ZT9EXA9fuw-mnBzzb1cA@mail.gmail.com>
 <CAOesGMiMiqk1mKcVF8SwePhUS-8cAmM3Ut3f+qRvjz27iw7CTA@mail.gmail.com>
 <20140501184941.GV3245@sirena.org.uk>
 <CAD=FV=W3qxMqM+cu-gEKkL4kNB-Jvo6-0tdt=L2madA8RLbfkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rPU94QKZZSDlQsx2"
Content-Disposition: inline
In-Reply-To: <CAD=FV=W3qxMqM+cu-gEKkL4kNB-Jvo6-0tdt=L2madA8RLbfkw@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] regulator: tps65090: Allow setting the
 overcurrent wait time
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rPU94QKZZSDlQsx2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2014 at 11:52:28AM -0700, Doug Anderson wrote:

> > Yes, just about to post a fix.

> Doh, was working on it at the same time.

No worries, I dropped my patch in favour of yours now (though they look
to be identical apart from the metadata!).

--rPU94QKZZSDlQsx2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYpsBAAoJELSic+t+oim92xEQAJWmyGoqjVxxTy4gcE7qs43A
C39YCGn3jWd+AgipaURFjDiRt7cNoEJjR/W+foFZGvDcgp6f7OEsyh65fXMyiiZS
NZ8K+8GhT/bwXYxBQ5REczD+o9MWWSXCT7z4YVz5U/6bnWx1weeiZ0kJ3Ii3ujyq
E50WiTICmGtjy/VF4S2LKMI0FiMyOOv0H2betc0Kq6ng84AF4i7S1U859vXuhee0
tsPg/IdC7PO1gV/DYbm+8IekHhQxoPQwdkbNec1Nmqz/CYLzDJXMT0e7CEAUBPS2
Rt20SRFMgoViZHWvSSvic+Ww1z520C0Pw39zcBkyb268aD04+d6Gli5VUGNw3fRK
MZnJsiGco0g1Cjr45oh7yIR2BgAmuudw0rHKXIingpHPYLO94R3BT9PutpXBVXzW
RmAX+yRjYSEt+mJ3sF2NeATEk97A2bMM771lLR2ZvxbPPlvXES+os7ZZ0LeFBCY8
ZFUyM/L6XZMtrAfocR/unbvqDNgRDoQBke1RSAf0jg4jSs2SaoxXqdvuEVIf/YU4
IgrmqMA7lGVjA2Ab+QTEapIk+Y6Le7TaJIZC8AhMiehxIpCvfYFHjgGVyECJgEdH
PxMTroCXhMnQm5t/eqwXdovM08LbAC4KW5ygitPT1m/tRlAZZ4iP/o8wBIuReRS9
JLy1r3PAZteDQc/7b9kz
=S8jw
-----END PGP SIGNATURE-----

--rPU94QKZZSDlQsx2--
