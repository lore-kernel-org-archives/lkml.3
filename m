Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaCJJdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:33:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49735 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaCJJdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:33:31 -0400
Date: Mon, 10 Mar 2014 09:33:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310093325.GH28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
 <1394440371-29588-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZVbJiTJMCrlhTKaH"
Content-Disposition: inline
In-Reply-To: <1394440371-29588-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] regulator: max8649: Remove regulator_dev pointer
 from state container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZVbJiTJMCrlhTKaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:32:47AM +0100, Krzysztof Kozlowski wrote:
> Don't store pointer to regulator_dev returned by
> evm_regulator_register() an state container. It isn't used anywhere
> outside of max8649_regulator_probe() function.

Applied, thanks.

--ZVbJiTJMCrlhTKaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHYbiAAoJELSic+t+oim9HoUP/RQw9eK8sVYwqp8IFMNj2nmZ
QmPGULSle8+/iNN4yKWFY838uq/1zzttzO8V0H8sbCbpE3VPqZ72znPuw+AyS5Wn
kx6DuJviRodpugdW9+HZrRcx5BPraSO5y494uug2T7TH6WgdDrIim31DnrkCD3aG
9Ywmq2nbw+Zkt10QgXWc9EQ9TAM9jZ6rz8F6x8C4h+YKeYeYbgQf84tFhq5xV9yL
wx5+tvSusnobP3f0bOUejVkK9Y0ygonO1Wr67QFsTIsfGGt7cbrHqidPodisnJ6X
LPUDe1XRXPCYz6n1x4pFbcb+ia/kuymk7rF8y/ZjDjK8FsPIBf/BHJg+5vNmIX65
S/ZJyaf224nwK8+qZRbkaowidYYQ7viYy6+68bm+Jg83N+hON6bXaEMtWRfY/inX
ZzhGd49ekqxRPUUrjlI7vAwaBP5tvt6hsa2ohFnuVWBJDPxwlVm5jcngzPIST9fU
v8KGO3g0dzipNpKex8biiI/jzaDuUHo7dTTEURfmeQIxTWb7VE7WsRa7j2LfpTw2
RIUTfGUbq5Zf7KXG1YUDIJLAvzTltOt5mhrxvfpG9PECbmm/UHmWdZva3fzyhe4v
ipM9+7LxUNUH2gG/6eD7q2WkUWfQmDt2EAYB11T1ZGXncg80j19s9M2OiWmRanzc
CypRi2eT2e2xmDe8+OIk
=Hi9f
-----END PGP SIGNATURE-----

--ZVbJiTJMCrlhTKaH--
