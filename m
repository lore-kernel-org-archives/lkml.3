Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaIZUXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:23:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:53053 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbaIZUXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:23:31 -0400
Date: Fri, 26 Sep 2014 22:23:24 +0200
From: Sebastian Reichel <sre@kernel.org>
To: David Riley <davidriley@chromium.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Anders Berg <anders.berg@lsi.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jamie Lentin <jm@lentin.co.uk>, Doug Anderson <dianders@chromium.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 1/1] power: Add simple gpio-restart driver
Message-ID: <20140926202323.GA27687@earth.universe>
References: <1409167431-21155-1-git-send-email-davidriley@chromium.org>
 <1409167431-21155-2-git-send-email-davidriley@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1409167431-21155-2-git-send-email-davidriley@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Aug 27, 2014 at 12:23:51PM -0700, David Riley wrote:
> This driver registers a restart handler to set a GPIO line high/low
> to reset a board based on devicetree bindings.

http://git.infradead.org/battery-2.6.git/commit/371bb20d6927f204ef5a7887ecddb06b2501c0d9

-- Sebastian

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUJcs7AAoJENju1/PIO/qaay0P/1J8596X5x4Mk64OACKaA01R
zBm0FeLq4kqyGL5/mMAYQUTia2EtwPgx85ErTHH0LpkDZo/C2VLUxZQuDJXDinLK
3rh/IwB+86VsT8C88Vr+H1dhpJD/mjRXmU1sWJF2B4wtRAKQmKqG2zjOZ2RdcFTr
dwHvVatqgbf/K20LhRHJUvNQFZ9FwwCig5BeqnA/Buv4i0a3/11HdhOFhErqWNOW
fGX/RNWTTfplQyagtlKIDlEWgy5IVhIpyATuc4/7qmZwNwheBYnYJHcmY2KegVfF
FmC8xXD5VD98ywDDedCFG34fpz2N8boJMLmqH3C9HdAWu+upNJNSkrv9WIb7mYy3
OOV3u9bIxip95CRUNQLjTRjd/TyJABH3hVv8NOgetGHpnmWzZzBmA0LkdfZOTW00
DmHzEA+K5erQ8dJ6LFlDTm9xOgoT0++7trNwAMqVRMY8DkbgfJUJqpmwePD52CiO
Of4WLY/lpuJYe5ryqIj26Yyz9kbsCT3oFP5mRT2d0sud7ehhcLoGIRMdAlXIcVD5
uM+iNzvhBb9wqJJMiw8R6j0T2n8gnHBvyyut/JOUvgOUHiVbq8Z5q5tv7qhdjNxP
SZwmVnTWGK5hwMjfA4NX8zFWTg9og64PLstHnIcn2RP3OTnL5m2Y2WM3365yZlzR
KeGcqGvUU3yXsrWwAC8+
=aOB6
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
