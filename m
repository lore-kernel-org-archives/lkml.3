Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3F1JeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:34:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33080 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3F1JeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:34:08 -0400
Date: Fri, 28 Jun 2013 10:33:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Ankur Raina <Ankur.Raina@kpitcummins.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.chen@diasemi.com" <david.chen@diasemi.com>
Message-ID: <20130628093359.GA27646@sirena.org.uk>
References: <4B6D9C89CD8BA349A71B74CA32C47E5850DA85DF@KCHJEXMB02.kpit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZU25/NGocqLNwEGF"
Content-Disposition: inline
In-Reply-To: <4B6D9C89CD8BA349A71B74CA32C47E5850DA85DF@KCHJEXMB02.kpit.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch v1 1/1]regulator: fix for DA9055 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZU25/NGocqLNwEGF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 28, 2013 at 07:05:03AM +0000, Ankur Raina wrote:
> This patch adds support for usage of GPIO's by multiple bucks and regulators
> of DA9055 for enable-disable and voltage set selection.Without this patch regulator
> control through GPIO would fail for more than one regulator/buck.

This needs a much better patch description.  What specifically is the
bug that you are trying to fix here?

--ZU25/NGocqLNwEGF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzViEAAoJELSic+t+oim91P4P/RvyE+7n03hzw/KEDEhCg5xp
ZGY073NqagbKYUtLbRDpcYTJQjxvMGUyak49xbaxtakMFiWvA5MYt8eoJTtb8eut
pWhTqO1eMq2+IjOB0SLlHPE62Qi2VnYexqakkIICDDkxVsF3s67Tud2W9yE13+83
Fw/QzVZvrXPCu6XFy8qZh5ALjwltiG7yLHyrUM+WTFpTWMaBHhFQArVwLd5W/spC
q+puOPU0VwYsEYd0bGt/Fd38vrVwMfTS6rYpvy4qIwN5i9V5msXgYmBo+a+b/YfF
S9WL0xd1CB08mEV1rdeAV4yqdrEmOKx9VnsrcsLUqsaquhR09jh0OSUVmpt9hJl/
R/hpFybvXMxRSgqAsWhZtA6kSKepU+nDX8+oD+pWSZMB7cUMGO9odv06HFD+Mw+n
DJi/uW41q/T9gFWEi7hz/zDLSx5o+Ai5FoAus3E26gYplJNf9o/lSazloVPnnAhF
57NrdO8jmv6z9A0e5HChXNgihJw7ubVfIuB01nV/jivkHgpHNmG0cZWZhkzg4EQa
qdaeHJBX83pXk0z4vbdr9sRRDCevlskdjurk7cLoBX/zhYd8VQGc9f82EyaiCPIH
pX6/3j2Yy971pkrLMs1YB2uy3aloqEf8JKEIiRhxgAC2842RVcDBLIKEkjwLhPyx
8S/VD0hK0fIsbfgekHGh
=pY2S
-----END PGP SIGNATURE-----

--ZU25/NGocqLNwEGF--
