Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161773Ab3DEKXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:23:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45037 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062Ab3DEKXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:23:50 -0400
Date: Fri, 5 Apr 2013 11:23:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab8500: Remove
 ab8500_regulator_set_voltage_time_sel
Message-ID: <20130405102348.GF6597@opensource.wolfsonmicro.com>
References: <1365026717.10047.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ni93GHxFvA+th69W"
Content-Disposition: inline
In-Reply-To: <1365026717.10047.0.camel@phoenix>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ni93GHxFvA+th69W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2013 at 06:05:17AM +0800, Axel Lin wrote:
> All users of ab8500_regulator_volt_mode_ops and ab8500_regulator_volt_ops
> do not set info->desc.enable_time, thus set_voltage_time_sel() always returns 0.
> Remove it.

Applied, thanks.

--ni93GHxFvA+th69W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXqYtAAoJELSic+t+oim9p5MP/iPtnHiaC6J3nBcq2cTQwxP7
DO7Pl/PbpXNJdCm/RPCEzT3mCG/24N4Uc2fn45lPYQ3HYxRXxUEltvDBZ0aL+OkC
qOzZMJdvWhEjcYNhmv9WBfZjdvwVXb42/oDOrEU7K6X35aOQHy01ZMK7ufjtuIyT
JjGOhjGd8E1whQts1HtRoQKIDL+8rZ3lQIhqdMISSTxzcMEa/+92IQP/e9PdvT4m
CQqmeYtyOoiMoGtIZo9cYfAQKlDDdN9TMx2zrXHxDNMdz5YD+h7nSV9MUnms2Z5l
RNMhocxY9wq7iDTDDppaUkq2/9ZH8eb3tZ9UrlUNXqXjliOYKfRvrPtEpL4NL5q5
o0FDJsirvB6NBRL+TFBi/BPE9Za/MHMGtfuJJbld1nPAlcDU0eWMew8PKst0/BCP
qonHrqMxcYeMZLguLnLf5ZpEvz+JssWeNtT4ZaAIEk36GlTrjLNXa0AWsbZRuNbF
ksdWDRng1lT2iJ14f1tnfzhB9D+v+tC/5kzRVoVg+HCeFYLacxu5h9X2nOKoTjL9
qr7utTAA5qbTD1wI2LhQW7isr0e0sJXQqAdvfaGhFZ6ncHashUK2DeOf697GZuzn
PXBFQJrYngJARt9bz2j4Y3oolm+32F2qE9GpzbwoiAqE+inCTh+sO9FEK/Oi5xm3
nC1/q5Z3biPY/p4NjbR8
=AaQf
-----END PGP SIGNATURE-----

--ni93GHxFvA+th69W--
