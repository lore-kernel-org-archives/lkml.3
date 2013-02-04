Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3BDThl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:37:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37640 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576Ab3BDThk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:37:40 -0500
Date: Mon, 4 Feb 2013 19:37:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 05/73] ARM: ux500: Vsmps3 controlled by SysClkReq1
Message-ID: <20130204193737.GU4720@opensource.wolfsonmicro.com>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
 <1359978868-28736-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4WCFFtl4AQpQKunj"
Content-Disposition: inline
In-Reply-To: <1359978868-28736-6-git-send-email-lee.jones@linaro.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4WCFFtl4AQpQKunj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 04, 2013 at 11:53:20AM +0000, Lee Jones wrote:
> Vsmps3 is put in HW control by SysClkReq1 at init. The
> corresponding settings in suspend-force are removed.

So, I've applied the patches up to here though I'm still reallly unhappy
with this code - it seems clear from the comments that a lot of this
stuff should be using regulator constraints to initialise.  It would be
good to move this stuff over to use the framework.

--4WCFFtl4AQpQKunj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREA37AAoJELSic+t+oim9VNgQAIJgC+4kLg3gVwpSLxFn54zl
0ob3n7/g56VANQCZTwBBS9vJsSOy0nmfcZZTDLxl/7e3ZjgKawB23mdDemQHHSVB
iQoq+/azYDQriPkILeAk2xkeLP7mpuHyEmkb5MzhZ5Hs9OQUWMeOc+6f9bKYc62R
bwMt1gS9ytPgwSzchfbcOJul5llSpgzOrYOtrUlejEuSZsG7wpGTTvsL9olLSVWv
ZVYbnKSbq9gFPh4SdbDthRw8w26LZHMHSBtqbdIR9wLMcrQKGUu+ywODwLrzODtb
4seVPy0cStFdDEZrs3O8LLE6nsGDOxEH9rUeoWUBInXHXuNGsTOfU8RdEPzlXlW9
iVMLL26djtzLk9QlB1kGgYL6N8WT+ayjFSkHVGXFg1EW6IAusyNwZsGg7Ydq2IHs
XuJ411RcdAXLlMYrUDQruH+2U1lEEEOkHRHWsn/gLn9UuRtYufBZ6asnYIYE8QxC
y5ci8UYFCF/xQzdT18fdJp5zWF3w+PAgnUdEniZ30pRbodANDUuoeDY3LGgeY8QL
r1HH0ms9MAx/03yYJ8htiptR/NjvMZbFZRC/Df8dS5f5+51MVGG2ahrGeG8VkyWL
EeaJAnbZGud7CVWHPrxrWhtzyYw0Ylh0GBGdrF8Rx9PQ4dz9Q70KMP5hTC/yEEia
kNy8AOC+UQverh3lqR4N
=18RG
-----END PGP SIGNATURE-----

--4WCFFtl4AQpQKunj--
