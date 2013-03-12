Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab3CLSZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:25:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51770 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355Ab3CLSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:25:29 -0400
Date: Tue, 12 Mar 2013 18:25:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Initialize `map->debugfs' before regcache
Message-ID: <20130312182527.GF19942@opensource.wolfsonmicro.com>
References: <1363022822-18859-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ni93GHxFvA+th69W"
Content-Disposition: inline
In-Reply-To: <1363022822-18859-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ni93GHxFvA+th69W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 11, 2013 at 05:27:02PM +0000, Dimitris Papastamos wrote:
> In the rbtree code we are exposing statistics relating to the
> number of nodes/registers of the rbtree cache for each of the
> devices.  Ensure that `map->debugfs' has been initialized before
> we attempt to initialize the debugfs entry for the rbtree cache.

Applied, thanks.

--ni93GHxFvA+th69W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3MBAAoJELSic+t+oim9OA8P/jtje5PFGos9grz1TNMjPIng
+bXgwgbKfutZm7xqSbpzuGJCDLQ/YO20LYP+wAz4+nKvJ6Alu5pZBP5TsuxAN8Qg
snuaX4m+N87cDNk0AYCTQpb2yNFi6gAV7tgZUCchpDyXnVSi+xl76zhrFB81WRQr
0NPlTJmqAS8zeKR8k5HV+qZ8I6oNr2xP++MCS8gWKXyNpfhBypca5C24R5CBPgn+
HNUhSLi6Lq01wLdKegeQpF20nA1X19KvXDs796Iue+Z3IDwooWNxo5n8oY+V9L9g
HwA4wqQcc+M763n6ybR0BEpU46eYmUmHtzkW9hRaSbJ6zu5rlDoIpfiMHD37BzPy
/zzgoQRwTwANLLSvM0H2kPBPjLsOk/VDNUgWF5ddZREW+BdUpgKT4efbvs/+EvV+
wbQ0kjPw1+bCjsjd6MC9GwdbZg3v0i2qUz4R/WcJKRsf9jAIH80V6ky//tJomXme
ob4acgWp68pCj+F0Nsc7C30RTQrzoy1V7e/egGbNYCBaJGWq/1RGr3MxayMLfSFn
HQUIY/sLR8DXQKyH2NzUW25vv5Pvfqp5E9HYuF6d6vQrfgpvxD++vfWKB4Ie3DgY
fnB8WwsqjOyuIRFArEBsA30dTTwOpfd8RtGFNiSbEH6XXOw5H7GOBUTOP8F8qPTU
c38rUmWXjUFZzlW6pCUQ
=QvOe
-----END PGP SIGNATURE-----

--ni93GHxFvA+th69W--
