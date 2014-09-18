Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaIRWXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:23:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51584 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaIRWXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:23:21 -0400
Date: Thu, 18 Sep 2014 15:22:30 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140918222230.GG7960@sirena.org.uk>
References: <1411025505-21628-1-git-send-email-zyw@rock-chips.com>
 <1411025505-21628-3-git-send-email-zyw@rock-chips.com>
 <CAD=FV=UdSQZqGqY5XvLwKpkSbEWvtXG0s1vuk3xfdX0AJ27TBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0za9BfvgN4c4+/Ah"
Content-Disposition: inline
In-Reply-To: <CAD=FV=UdSQZqGqY5XvLwKpkSbEWvtXG0s1vuk3xfdX0AJ27TBg@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] dt-bindings: add devicetree bindings for st-pwm
 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0za9BfvgN4c4+/Ah
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 18, 2014 at 02:27:59PM -0700, Doug Anderson wrote:
> On Thu, Sep 18, 2014 at 12:31 AM, Chris Zhong <zyw@rock-chips.com> wrote:

> I would be tempted to say that you should add a few required properties:

> * regulator-boot-on
> * regulator-always-on
> * regulator-initial-microvolts

> From my understanding of how PWM-based regulators work there is no way
> to "disable" them.  If you drive them low then they get their biggest
> voltage.  If you drive them high then they get their smallest voltage.
> If you make them floating then it's equivalent to 50% duty cycle
> (right?)

No, if there is no disable operation then there is no point in
specifying any properties to do with enabling and disabling as they
won't do anything.  This is only relevant if the operation is there.

--0za9BfvgN4c4+/Ah
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUG1sjAAoJECTWi3JdVIfQ90cH/3AAZKacvouTl2ZFS5tSIJL9
+iqPwnjD98RRl5mSKgV8EVf37P5x6awgoVX/F5IPWHdPJk9pbVKZQLT3xucFCXtm
YLLsqDTZljKGUfPUpq7OjCk2qfuxGK7IDTTHPn+WYXaUCWWJaB7eduwPU0VgTWq9
/z/nKy5kRBH8EktvnbSkRj3Hj6fkdiOUBnSzPiZjTKcbUlS+WxxWBzJrgzLlJWWf
aucCqKGKhtpz/7gBruPfqsV1eI6h/A1zCFQFbbnQHevwW47bJPLZrj9wJ1ciR44g
93eNkehYCoTpFnGoTt54CKaWlPwResNwmapjvvo1MFjH+G587XCf66MbyJwHHuE=
=VlF1
-----END PGP SIGNATURE-----

--0za9BfvgN4c4+/Ah--
