Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaKUTWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:22:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34088 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaKUTWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:22:45 -0500
Date: Fri, 21 Nov 2014 19:21:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20141121192109.GK3815@sirena.org.uk>
References: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
 <1416512485-7292-4-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z3MQA8rgdnnmvulu"
Content-Disposition: inline
In-Reply-To: <1416512485-7292-4-git-send-email-joshc@codeaurora.org>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: rpm: add support for RPM-controller SMB208
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z3MQA8rgdnnmvulu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 20, 2014 at 01:41:25PM -0600, Josh Cartwright wrote:
> The IPQ8064 reference boards make use of SMB208 regulators which are
> controlled by RPM.  Implement support for these regulators in the RPM
> regulator driver.

Applied, thanks.

--Z3MQA8rgdnnmvulu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb5CkAAoJECTWi3JdVIfQYsAH/3ec/LSQqK0va6WPmRwEqsf/
guDrabfp2f8tXnbyNsRS0paPgmuXkYj8x8jUwRbxUwN5fQ5u9oZsWhfvioHd6rGu
aABrKgOrfYvuHUD3moG/YXjwuAd1CBxWDBjzpxmzLLMTrGb2VhX6B6+mrNBU8Gxs
y7XMXw4KCnsaNaWj9qFqhAd9dzReOr7ItVBWWpWxJ8U46VonMuvUHKwrjA/+M4ln
GyGWy8chV8Dw0ld45TuOmqivZ+2HFUTp0H2BmxIUhzVW7k/mz83SVEqhm1M1Cv8R
KzTm3h+GWVq3QLBl0xPOb4jhqVzeFQtKzE9dY+ENAiarIkZEdJKfo2smLF+TyMQ=
=KyYL
-----END PGP SIGNATURE-----

--Z3MQA8rgdnnmvulu--
