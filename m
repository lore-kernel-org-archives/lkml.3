Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaB1GTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:19:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53539 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaB1GTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:19:32 -0500
Date: Fri, 28 Feb 2014 15:19:20 +0900
From: Mark Brown <broonie@kernel.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: iivanov@mm-sol.com, gsi@denx.de, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140228061920.GG29849@sirena.org.uk>
References: <1392890528-7417-1-git-send-email-iivanov@mm-sol.com>
 <20140225.225528.453119424.anemo@mba.ocn.ne.jp>
 <20140226001407.GM2927@sirena.org.uk>
 <20140227.223826.522636360.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HB4mHL4PVvkpZAgW"
Content-Disposition: inline
In-Reply-To: <20140227.223826.522636360.anemo@mba.ocn.ne.jp>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.153
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] spi: core: Validate length of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HB4mHL4PVvkpZAgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 10:38:26PM +0900, Atsushi Nemoto wrote:

> I don't object to the whole patch.  Validating in spi core is good of
> course, and "xfer->len % w_size" part looks no problem.

> I just want to keep ways to handle an odd device, for example, which
> requires long delay between chipselect and the first transfer, etc.

Can you submit a patch adding that support back please?

--HB4mHL4PVvkpZAgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTECplAAoJELSic+t+oim9rkAP/j9SC0inyk1XgVXIOeURtMnc
kOZJBOfxDozRF0g+MGWBNaKXQoedBAl/Z1ZTSynpcjiJVEwM+8xMRqcli0Tot7Nt
fmAmjUQuJ2htxf6l/6gDgj/zUaD9aVaTW8vvaz6DCB9qUWUrrRHZ/UgDhFqheYII
i5RV8Pdy9qU3Ozn5Abkjznf2CmhKBF6j40aXvoE4fT39wExMhRUBv3fjRmgJgww8
4PQVKc5s4lJcXy7ioswhX0BjKOIb8FBBV6tsIJUbi3niYKsQTcvfUsmQ4J4BNpx/
YQ/fof7zC3OEQWZ/NuOWC6v5NxOq/jcRnFaN2N88SYRmRMVV2VFIVgt30LVMl/Sk
JLuCCugUIaAjlA0UK/1k8tKBydBJeS2vtfTVsUoPbaUwVz4YhZEMD62EbmcvAjJf
eXr0g5hN1/e5fd6gTL9D+506uT7Epy3ERBRpJWx5aTNXwqwLiN0Kq5YPuYeOxLH4
N8s0ndV8lOaHqBTI/NZYodJhbS3P93YPBqW5fonLfpCb3Qd8xQiCjxaLnTMccaf0
HH6ulEJg154jh4d3BEXgD1orEgsh8oYdhLjMGpA1ucnO0l3hy4y72W767uZwABC0
ahFfrTZ3CBERDMpHrnMK1Rfvh0dMjJnvBeiDlglI3QLzAhpJ81Sojv+CggDGhHR7
/rfzq+ZxcwkUUWbnk5bv
=n9Rr
-----END PGP SIGNATURE-----

--HB4mHL4PVvkpZAgW--
