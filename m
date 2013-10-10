Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3JJRgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:36:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42635 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3JJRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:36:36 -0400
Date: Thu, 10 Oct 2013 18:36:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131010173627.GR21581@sirena.org.uk>
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
 <20131010102826.GG26954@e106331-lin.cambridge.arm.com>
 <52568B3D.7020209@samsung.com>
 <20131010165100.GA3910@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="myWHXexGRVC5aLMg"
Content-Disposition: inline
In-Reply-To: <20131010165100.GA3910@e106331-lin.cambridge.arm.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s5m8767: Modify parse_dt function to
 parse data related to ramp
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--myWHXexGRVC5aLMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 10, 2013 at 05:51:00PM +0100, Mark Rutland wrote:
> On Thu, Oct 10, 2013 at 12:10:53PM +0100, Chanwoo Choi wrote:

> > Turn on ramp control of buck2/3/4.

> Ok, but why does this need to be in the dt?

Ramp control is a hardware system integration decision which people
working with regulators should be familiar with - you're trading off
speed of power on or voltage change for maximum current draw from the
regulator supply.  The term should be sufficiently clear to an engineer
who can make an informed decision about using it.

--myWHXexGRVC5aLMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVuWYAAoJELSic+t+oim9imcP/jJVzRf/7IH32ah8qXU+rhRR
OQgSUjup+4bzVDTl6O9NwCfuCZmuVjKu1uniT9pOd1oxLOZL0TSwAq5Srif6AyBi
/l3a4a4OyEVFVLyE7Sb8ik/F22TeeAj0FBS2+LFRchLZmRR5+dzBAVUrP4t0Tg1D
I/5qQqglAhzzjlDcHrAzMwlyjhp/zmpnK1huosBbQigKc61Ux6JSBqKeJwrvcliM
8olKPXjlcVz+PCazM/EKtW0MbR5InJbr6VTwWrMlrPZWfeyZv812DsDmZS+DlKID
sNdiZqTRQ9Lox9sjzrpkN2YzHsfWNfmsUkG8lco+UN7hlFPaN77BiSkxZXqth3YS
ojwFUOyxbChkblCnYKLQSh45EVwHDa+r71Mz65NseiVULMokJtQ5GC64R4qzTcys
5S9aeBq7L7Cbjgf+Dv/inB5VwJnmxI5wnN9kZtWRT7rlH4iVazuxIH//Io/lDf+T
RCBTgH2Sx58auMv7UwegcDXfK+Re8HEM4Ov0Z3q6UB70NTk5R8kAUtSPvnrNNjFM
QmMxaJukOsEY/i+wfCjFzh0143rYFMwWWUOKCAbA796k4il6hgmxVW9O94JSdDDD
/1jIEBLWeDGav8DQULfdckolAqcuS4Wka3NYCh/6TenIC/JE2jAs+YYuf45J6REg
61uBvt77tIFods5lLV3o
=9dzG
-----END PGP SIGNATURE-----

--myWHXexGRVC5aLMg--
