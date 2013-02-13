Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009Ab3BMM4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:56:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932599Ab3BMM4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:56:54 -0500
Date: Wed, 13 Feb 2013 12:56:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: as3711: Fix checking if no platform
 initialization data
Message-ID: <20130213125652.GD5062@opensource.wolfsonmicro.com>
References: <1360719288.14930.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <1360719288.14930.5.camel@phoenix>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 13, 2013 at 09:34:48AM +0800, Axel Lin wrote:
> To skip registering regulator if no platform initialization data,
> we should check reg_data rather than ri->desc.name.

Applied, thanks.

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRG42MAAoJELSic+t+oim9wikP+wfC+1PdjLDZKpZY85eSSG/0
q8/rOuWgMA9c1FKVpoirP8k5FwDsEbEYW/G20kagDtbVhhzJ9coXVc98C94WqShL
n6h3fMZquU0W8Pq6ypob13KFyfvwPtnMi7N2eh5c1DidR9FeENGrSujfhvDo6IRu
7frFyLyGC8l+Blfw5DcVo1cDZazPNo2B5ZOe3Ern341sfBsUtqq6cEioIn+bxofh
ZmaaC7vW1pgbZcpeJ2ts+E20ohlQbHr1IPo13D5TOwnOwyeOO8n5eXHHsJ/2U148
0zH/wkkLayyNr1DPqFyEFGPxSgL9PdeUGBvQvLcVzEAqR9xX35Mlt9+7sVhmOeKV
bWFgb8aTgRTTv/muY6MoYJfgWn0/M1px4a9xMMAEfr33KygiqtVmq3JCumsvQupD
I9eXcwrT5Zv6IaRLJCzB5apWF7Y/2UdxWykdAecNczohTGyp3LLXHRMu0JRUCGBq
/tOlb3eRpWMRKxboVpJPRmBYeCCLTTdtmrD61pRXK0NFOZo+FsD0G3x54m14vxHx
0e4kcp4SHWE8EIO9wktr+qIAaIwnQkV7e7HVsKY06mJ0/N3vYYuWmVqKme5J66BE
mdky0YwkuYHOqdeGd8V1nUvjIg3hfPYVLWyCAvfJw71fiuwyIHqB7cUb9y2ODnr/
6SH/4CoUct3J8vpK5Zyn
=Gcf0
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
