Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbbATQO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:14:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54776 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbATQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:14:26 -0500
Date: Tue, 20 Jan 2015 16:14:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <20150120161406.GB21293@sirena.org.uk>
References: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1417038661-30209-4-git-send-email-bjorn.andersson@sonymobile.com>
 <20150120141954.GS13701@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20150120141954.GS13701@x1>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 3/3] regulator: qcom-rpm: Add missing state flag in
 call to RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 02:19:54PM +0000, Lee Jones wrote:

> Do you want a pull-request for this, or can I absorb it right into my
> tree?

Just apply it.

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUvn7OAAoJECTWi3JdVIfQvC4H/2t+7GP8eK6yFALo/UGgHlKX
4rcBfdPvzoGYSc/KEuqEV8xhuxgD02JvKDQExmcVLi5Katg9tQZqHVH4pKWqRSON
tEdKmFaJjNFP7W2n/9JROjU99ZMv8gQxzUTlhnGmpklM2VvCa/Dxtxd/4xTyh44p
+X+K3SpiXjIugL99H4yquF/fc450J6Ie87vMW+9pHm+/O1QKyY/Hd3SQIe7uz24p
Fk7CqTJ6VI2LU4LUkzGUIMAp0D8lA9MGbQ4rGpu/Du/67YinzpoDj+EC/aOo3AIt
5KpoNjbBX52XxP7wXfLHVV3DbWX063bte9OqKFb02+zkjNQd37Ms3U76siRlZ1Y=
=l0x+
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
