Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaBTLXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:23:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47243 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaBTLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:23:47 -0500
Date: Thu, 20 Feb 2014 20:23:34 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220112334.GZ2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-7-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2sUs6tZddim281Wv"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-7-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/23] regulator: max8907: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2sUs6tZddim281Wv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:07PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--2sUs6tZddim281Wv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeWzAAoJELSic+t+oim9geQQAI/YTBQSHjD7/Qvof+oW3Rnb
NddeWQA8K8xmyxR4QlcnvlRKOZurpK3JFlDGvL61fjMdtYRzWieWw40VQDxH1Sh3
IwY5bUuN0QANfPTAQvWnnk9UEDx4AMwWN/3h4D9A3F/N2AZQiKpUSjKNPrvUySDR
CLimeVPfIQ8rIdYm8syrUcuwgvkjf67Zz8rV8uVYAUcuLz106VEyXOkvoNjPN3F+
4QXHmun5I+NBQSgGsNNIId8hDOazAIt51h36iJxpc+s6q9Pxp9cw/TztuHHpcJMB
R/N27rJghrKBCbkoyMKzTUPDlIqdmrltSgmoMTGG7BLw6X0rWCNV4vM6+AIbYZbf
6OeQJuX4tLmr54SAxfAaEo/jrKb1PwV0g5KwCGlvSaORlkSLSsgsSGF298fWbfqf
oq+3CW2zhkamPamkQJQQ6goVb8Pg1roBO054r3H747lm9v+GncW0i22UQ6RHRCm5
g0kwc3TlaEQ0IpOFtJcuRh/OUvzmgwgaprtYYEO1nTGTxgqqJPEGOymaEni6gZta
inGGy+HpmNbZ1hJlWfqECJCqZzDH3vOi3WzC/8ah9ICAM3LFE5AWNmd33EaH2jjs
tgaLtPH8/ljB2mfboMlPN4NW9UOMPP5tSwcRDipkTQBWKhl77IvLmrsIB7dq3eBI
s5d0BDS8vlNf0PS2B3im
=tsAt
-----END PGP SIGNATURE-----

--2sUs6tZddim281Wv--
