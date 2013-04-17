Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966488Ab3DQOJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:09:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46244 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966321Ab3DQOJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:09:39 -0400
Date: Wed, 17 Apr 2013 15:09:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: ab8500: Don't update info->update_val if
 write to register fails
Message-ID: <20130417140937.GQ13687@opensource.wolfsonmicro.com>
References: <1365509706.3801.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wr1Q/2bz0MCWWNYv"
Content-Disposition: inline
In-Reply-To: <1365509706.3801.1.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wr1Q/2bz0MCWWNYv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 09, 2013 at 08:15:06PM +0800, Axel Lin wrote:
> This patch ensures info->update_val is consistent with current register value.

Applied both, thanks.  Bengt, please delete unneeded context from your
mails - it makes them easier to read and your content easier to find.

--wr1Q/2bz0MCWWNYv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbq0HAAoJELSic+t+oim9qtoP/AgLwPvfUV6APLBFhunpbAMk
6N+l4kGzZ/uOzqHw7L9JuR6WqfOrO+8EHiYXQLnr7Y6rCFhsaLgd5lFn+1+tzO7s
k4FG+rBedSeZEy6dHVSuFVNzTDZGrtOthz1cLvU+cPacoWwxo33z+q9AxkDVOvVi
IB33MriBzQbz5hLmb28JRIz0pGWbtcdELI6orM8HXG/7/p5kxuKUZ0AtBWMvzgDB
w/unayvkwEFKDze4iWESdxxJ5uO1Ud0q066Y4ndI6SMpe3SsiGMApITD1IaVrnS6
yYcrqRJEmIqkqdzjX6nl5Z9RfJk5b0khwnDEs9tqtHgNQPWDTvdE49z72sKYllq1
WErofBwe7jMeV55BEtbRKEFtFs3ZHnmFQCv2VUXQF3EdFtJaGLup7EcFbmxhbLZ+
LCI8VP+qym92bQOrgmyLeh4ZfOrlWs18eInxcUmn7FLdbRxZRzHYXQDb+i1T0Smg
pHV93NhmEKT1eI1cJYVtI550hgIb/XOxN3PJYDio+HurdD3tL46uTihgIL1qXr7N
rcGummGOhyw7JCMGU7FxMmG0hvXoo4Be6rJXiB/0JIXNbbpccgNggVlA6rjNcsUn
Y7SAf1RTZGXb2WveTL+PWmPPs+yRFfxn8zdbaEO2YK//X8vsy5ng4/v59t33Pg3I
IasJuNNJEAO+s4CARFxs
=kHHu
-----END PGP SIGNATURE-----

--wr1Q/2bz0MCWWNYv--
