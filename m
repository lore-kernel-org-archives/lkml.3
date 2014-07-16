Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965541AbaGPRAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:00:30 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60846 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaGPRA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:00:27 -0400
Date: Wed, 16 Jul 2014 18:00:22 +0100
From: James Hunt <james.hunt@ubuntu.com>
To: upstart-devel@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Upstart 1.13.1 released
Message-ID: <20140716170022.GA12486@faire>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Summary of changes:

* Fix for Session Init crasher triggered by restarting a job
  that runs 'initctl unset-env' (LP: #1222705).

Kind regards,

James.
--
James Hunt
____________________________________
#upstart on freenode
http://upstart.ubuntu.com/cookbook
https://lists.ubuntu.com/mailman/listinfo/upstart-devel

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTxq+mAAoJEJ1Q4UTmNXMnvZwQAIGc27AJYQO3jVlULQPuUTKZ
wXzuN1CFVin3cqkJn0fUXSpq5Htf8MBC2THHIkr4KNWnc52Se0NsoHI+Gc9kaxsd
fmz0gjsb7a5f546LKU0CyxWJ5MPF1jR5ahc9LeZyEYzQb4bdE+1tFH3nSDmpMRBv
cFB2zpj+mBbm7YGap2ZhDXHrePvxAH1wwszlE/CurUlL8TPxV/RKG1u4Mq+Oyub7
FTJYWP+QYB9TJrPEQ1KgB+Mw5ft+aG+IVzOdNmDAZ4Q1te+64zUptvzAM98y/Cz5
pbbo45W/Tfm8eXx4hVLUDjjQXx6XJZiVCcOJ0uXeCoER6g1BGeWGqCVgcmFEulFx
S8uXxdCydakWc+6BENycnsFks8/UjCgsupH5OzUo4a91rtI8NNNRrwYE/QSacw58
/1x+WTVl5wdOX1i6G6K+KeGHyeiChI3oslLyflnZPhLlmvsIJrPMrF3fe6Fzf4q4
rruP8lEHCCdQSLqJ1ttvWUDTWK3fJOkJB5DRG3Y60SmRAssngmE4/um95A9fObaW
mcUvKPjZoiww13fSWqwykUnIA8nBQ7W66HurLnVs2morNXAYRpmgjSt2P3AhLmNz
QLLg30kCEffwu8EjsnsosX7h26V37eNqEsNjpuWUvKLL1W3vjDgrvqts3LgvbOK6
PnHOgsdY0bzNp7ZsW3Ie
=+wBQ
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
