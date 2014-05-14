Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaENPR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:17:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44686 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaENPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:17:26 -0400
Date: Wed, 14 May 2014 16:17:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Message-ID: <20140514151709.GF12304@sirena.org.uk>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
 <1400016884-9568-3-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UhVWQSjpoPaj4pDS"
Content-Disposition: inline
In-Reply-To: <1400016884-9568-3-git-send-email-agross@codeaurora.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] spi: qup: Correct selection of FIFO/Block mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UhVWQSjpoPaj4pDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 13, 2014 at 04:34:42PM -0500, Andy Gross wrote:
> This patch fixes the calculation for determining whether to use FIFO or BLOCK
> mode.

Applied, thanks.

--UhVWQSjpoPaj4pDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTc4jyAAoJELSic+t+oim9Tx4P/0ZQCKiZfZiNceHJ2fEB4gDE
Nh9VP8TRa1uTvJDE/ea/WcYYk3zX3/PpYpbsqUC2/FWc3WCUkyQRB6C9tEdSYOrR
tKU63GJ0aQleSSAMknYmBh133L3GTsMAF04+j2bA2N/8VmXrIjpAJOkmFqF3xYqJ
fNQxSktY83gSQ362GgmjbxziAUpC9bScm1nBUqOMMTdcIiPtjL14RO3B81r1BwQ6
e57xKP6Fa3NzBz0Z15iFRaE/1erlX6LsAFBXxOrM0UmeagakUMOBlb/xfxNxKkYP
WQ5994anGRi8ym+ITC7SQJBg32dKl9I107oVOCPeZK2TlcGkH1AcDa65e+V73vGQ
iE2rpwhgVjT0u2kc9IN1k7phGxUKgJGmnoptBtHI/ckfN64yLFNIbE6/Tg9LFLMr
Be3AptzUwGV1AyIE1qQ6NkJxPhH+tEcGLjGvkIDiP/j8bOf6HlLr/oF3GiqEfm2M
aR3pKje3SApPoarkLRyYi2kircIT1KXN++tRIbsQihFiGNmvQ0Gdeev+U4Qg1hSD
4zXrFc9RBRffrvKe68MvI8nwJjk/LWylqBKAV5zcHdY108Rk6n/GIrmsJ6hUoev3
+G2RFgdPPaQ/cepDTIqsu0i3iPEzhN1XUHVUrCh7sztarRlhSejHTIVOyL+dbZzi
W7OIrledQ17b3Q6uxABR
=RDjN
-----END PGP SIGNATURE-----

--UhVWQSjpoPaj4pDS--
