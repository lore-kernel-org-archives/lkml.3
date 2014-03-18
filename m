Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaCRMkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:40:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59139 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbaCRMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:40:05 -0400
Date: Tue, 18 Mar 2014 12:39:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140318123959.GT11706@sirena.org.uk>
References: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
 <1395138184-25287-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yktCVXu3+F/fxPc1"
Content-Disposition: inline
In-Reply-To: <1395138184-25287-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] regulator: max8660: Silence checkpatch warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yktCVXu3+F/fxPc1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 03:53:02PM +0530, Sachin Kamat wrote:
> Silences the following type of error/warnings:
> ERROR: that open brace { should be on the previous line
> WARNING: Missing a blank line after declarations

Applied, but...

> -	static const u8 max8660_addresses[MAX8660_N_REGS] =
> -	  { 0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };
> +	static const u8 max8660_addresses[MAX8660_N_REGS] = {
> +	  0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };

Think about what you're doing here - you want the }; on a new line too.

--yktCVXu3+F/fxPc1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKD6cAAoJELSic+t+oim9Gh8P/RAkHuQwWaAthv11hJVKP1//
vd0Yta29ANDpv5bPcbsJSrKHXNVbRUM5UnqgB5diqYBptTSF2NLyuIutyJJ6aAeW
AnSFWJYk0Sb4In+d4q9OeaxILFrAGeQq+gy+czQt3aNH+iHony57XQq7cYjOTX/r
AIRyEYu+UcvJgyA3XL3DbKNdbCh6q+ru+LNOrX1C5ueIZe5dtAcYDQVUxYNkSxQ/
BbtB0DlVr8035JzM7U6kLJ4jViSjoJ2Z2NQ9aVRVp+2OuMAI6aNkaAdZIlCAJzUx
pqyie3OoJQCsAXdChfhEO5Hu0ZCszx9L2ad05LbvGsGrgDG7NpVqxI5niVZHHO/K
vwVomtlMdwwGmgPJr+FY5x9yBREfCcUNnte4m5C4KD489PWJmvkuDRmO/+IkcbSQ
8H/ZkCOQGylgPN2H2TfJIBhG9dVQcpWO42qL9IIPZ7Q8o7APi7RCidod01iHMpM8
qnGc1iLp6MsfSOXA6RQUg8MRDToFrtCrdD9MwfQeOpax5QONg5PMgCr9q9y4/7JS
FPX1E+wnVjRSuSRNPsihNcYbEh3++pYz5lzJKe/SP/m6Llvd4R5qku0/ZyrPpXS/
REJ4fbyjkwJTnuwuzQA2MH95BJnwzKGMbsh52W/g4T2iapHuB86WdY9TjFNaoeB8
Mhjlg745Kzb2rZwUokQ1
=qAwD
-----END PGP SIGNATURE-----

--yktCVXu3+F/fxPc1--
