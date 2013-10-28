Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3J1UB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:01:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57580 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3J1UBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:01:55 -0400
Date: Mon, 28 Oct 2013 13:01:23 -0700
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Message-ID: <20131028200123.GA20439@sirena.org.uk>
References: <cover.1382985169.git.joshc@codeaurora.org>
 <cc2f82e353885734fe61bb8d8ec8c9f7b35e0d5a.1382985169.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <cc2f82e353885734fe61bb8d8ec8c9f7b35e0d5a.1382985169.git.joshc@codeaurora.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 07/10] regmap: add SPMI support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2013 at 01:12:35PM -0500, Josh Cartwright wrote:
> Add basic support for the System Power Management Interface (SPMI) bus.
> This is a simple implementation which only implements register accesses
> via the Extended Register Read/Write Long commands.

This looks good - I've applied it on the assumption that the underlying
interfaces won't change and the suspicion that it'll be after the merge
window before users get merged.  However I did provide a tag at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/spmi

which I'm happy to see pulled into any tree that requires it.  I can
drop the patch for now if there would be a problem with getting it in
during the merge window.

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbsKQAAoJELSic+t+oim9oPsP/jO9Qws+dqtbWlXqTRXI+/Od
x2UzTT4wbBphfDMz/0iMkvNeVCra7GAQH+hfLrd6twzrFVnkmy7PNJZkyZt+nLxa
gR/kyWP3RBo4EX+Uk6E/ANaYEeTGf91O2gjsWhiDm+Qu+7gXaTreleSlnFdzfREf
d1cpgMziW1qJ2I9zhFbwFnRgE5JAWY5AFq3JdlaWpe41EOf7M4alnrlqZYBHLQYd
lDtAq9AdsNmyOqWDzR6V8OMAojTVjUBWM/8DQpnyElbz0q/L9ppG14JsqcWgbFnY
r+8jyRsW4k8MuZEdmZCorFVr+9j/IgXIuSTmdvAkaXTH8wKUCVSAsw87P4vkDXSW
zm/OdwMq3J994cJyELt/lSSmGqQ/GF3k8I562wJ8/CzyuSwydjP3XkJDgm3Ylvex
FaPV5A6cDALiK5HEdgASdk0j8ecBah3Q2OLlwhkxALQnlVmN32rqs8MSKb4i/21z
LGemEE5v47pLmEH6ujoX1Bzp3Es2K0xH8XTS7kKXVk/zqLNndcZVHfzuIw1/fltp
y1fssfx3GyKwnNpgLIkmNwzcbCSq3lf84LO+9218lrKq746dVN2GpOdTGzdMvktU
4mfQeq4oAw3tGlWt8US1gh/zJQB4TVa0YF2ncm3Qamqgtkr10baHCrAlsTRIBJza
/IzHzbTR7JgJrcbE4/Ix
=Y09s
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
