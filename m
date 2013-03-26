Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab3CZT7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:59:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35540 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023Ab3CZT7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:59:20 -0400
Date: Tue, 26 Mar 2013 19:59:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] regmap: Cut down on the average # of nodes in the
 rbtree cache
Message-ID: <20130326195916.GL18316@opensource.wolfsonmicro.com>
References: <1363359275-634-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="en6jyp4HM4Tn+Q16"
Content-Disposition: inline
In-Reply-To: <1363359275-634-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--en6jyp4HM4Tn+Q16
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 15, 2013 at 02:54:35PM +0000, Dimitris Papastamos wrote:
> This patch aims to bring down the average number of nodes
> in the rbtree cache and increase the average number of registers
> per node.  This should improve general lookup and traversal times.

Applied, thanks.

--en6jyp4HM4Tn+Q16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUf4OAAoJELSic+t+oim93ZAP/0pIwMjm1yl+bnF2vd7Jp+6k
XeXupZW138XcXuWadrDv0nLXyUHIIAFKwPLLnvoTBaJF2+WPKPEcOOzwza5aVh8R
ZGzW/bkE9MamXMtyH91sR2hGOBiz2i+bn45fXfJb35Zt0Cfzh7HXJMrBa4jUUCiy
onByuzLIOlukr2eP9FnVG8FVP/KqBHCgMWgHbC8qMTs8DqRyMJISTzFabdn6WDsZ
U+AXknc6vQumsy6gI89sG1PgBC0+sC2u8Btq1JA4aJi1sNqepvuevQigMF3+XjlW
uf+NJuu8e+0y3hzxmhWR9HzgNvaTseN6Al94tX8ww97iBZKAIhDCCG/jkKe7azgO
O/G3T7AUpGuler/n0jfMiVyKNQqrMXxfLyz+hTwbDcDa+k5XKUfCyzFkc/euvsJN
cKip/sUPN+s6f65jZ2jsHxu5yQBUf2Q0dd8UkZ79oohIFtTAoxT9iTgvocoZ/Myq
uFozhdpWPFvnkRqK3lYJ3dv2TRtfLn+ihoEivTsBOVo0z3xYCmp7HNTPEwtAUUX9
CgGAeCOXJnbra9IDQqG6nQJ/W9se0av4VLBsXZbT12IihRx8ibhy8u7DLeOs6N2M
ov0TnbjjLKWClOl0LYUbs5pO64JJdkL19N5mB8n61TqOdzkljR1GF7JkKN1kTxyW
Yg6xhBrr4C8ksYfCNM8K
=90YT
-----END PGP SIGNATURE-----

--en6jyp4HM4Tn+Q16--
