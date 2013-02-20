Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674Ab3BTQsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:48:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42790 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933204Ab3BTQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:48:14 -0500
Date: Wed, 20 Feb 2013 16:48:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: wm8994: silence bogus warning in
 wm8994_device_init()
Message-ID: <20130220164812.GJ2726@opensource.wolfsonmicro.com>
References: <000001ce0e3b$f1d99170$d58cb450$%han@samsung.com>
 <20130219121801.GB23508@opensource.wolfsonmicro.com>
 <007101ce0f15$7a726410$6f572c30$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYo4Elh1vtcYNvbq"
Content-Disposition: inline
In-Reply-To: <007101ce0f15$7a726410$6f572c30$%han@samsung.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYo4Elh1vtcYNvbq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 11:53:36AM +0900, Jingoo Han wrote:
> 'patch_regs' cannot be used uninitialized in wm8994_device_init(),
> because 'patch_regs' was already guarded by 'regmap_patch'.
> Thus, that's a bogus warning.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--zYo4Elh1vtcYNvbq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJP5FAAoJELSic+t+oim9zYwP/0Kn+aX9N6+69pvgfcWG7d/G
Hnttux7hCTV901HAq2hCcyK6IB5rwSgCtEXYp14hISv5Z420Th/48dEI7OLlMErX
T9hZwi3m/5vhcLaZfaKnxvQPRkd3B8IWomkkfxN7Gug4vZbcT6EhPzJmHmCEErbQ
CVJxIhdsl8jJlc/oSGtjNT9CI0Rup33tUKBBQZaDvKr3LeFpTrW5vwhzvJFSUG22
hbP0aP0bebyaKX5hRGCZJI79SYXvsFgx24sO6KTlJiexBW0NKRMZZuKDNhQC9Wm/
17A35cPTvdfHqrJLF34Ovz/z/0H73CGTTzj2F2k7EJnRElAf+35iY59ToZypZSMV
dDB7+yd500muB65DHWF8qEbok/ClfL2dlR8FQzzkoXHI7CuNeHrgise5B7HcCj6O
+ldXLa8rRgC2rBLxrYBHpPxwHtdV5Q+jLscNWWJ5X5SWFRbP8t7yAff7DsMP753a
FgLVFXbhwfs7t2E0/bYaUog8rs/NxPq3GLWI2SEWSkdWF7pBJJhOlFnw58pzTEVI
eRsi5FeoIC6hKSkqOcy8aN4ygOjKq4RRZfd+033d/XArWT5bkYEdPAUmme7EgfAf
11ZISSdzpLJklRsLpykHqfu4M5gq61Rsj0CdxiVfQJp+FkF0lmBKl35HSZu7+/bf
WXu4I0egrPWVZhRW+HMd
=Fg4n
-----END PGP SIGNATURE-----

--zYo4Elh1vtcYNvbq--
