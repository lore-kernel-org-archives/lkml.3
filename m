Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936076Ab3DKQ5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:57:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35612 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935114Ab3DKQ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:57:20 -0400
Date: Thu, 11 Apr 2013 17:57:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: wm8994: Use GPIO parsed from DT when
 registering regulators
Message-ID: <20130411165718.GP9243@opensource.wolfsonmicro.com>
References: <20130411162315.GF9243@opensource.wolfsonmicro.com>
 <1365698217-17771-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jt7EHN8kmSCh+bhe"
Content-Disposition: inline
In-Reply-To: <1365698217-17771-1-git-send-email-s.nawrocki@samsung.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jt7EHN8kmSCh+bhe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 06:36:57PM +0200, Sylwester Nawrocki wrote:
> Ensure the regulators are registered with a GPIO parsed from the device
> tree when available.

Applied, thanks.  Should be done more elegantly but I can't think of
something obvious right now.  Thanks for testing.

--jt7EHN8kmSCh+bhe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZutmAAoJELSic+t+oim9wWIP/1wEGAbocyuqm7ezZ/PCuHYs
tnVqg8Pv9HdLTdfoB2h/7i8CFEc8D3nPQYHygV5IrEznvKa99jv+hwQS724MNEQX
nsjMrJEDTNUCrsi1vN8qDZrsmQ5bAwXJkg88+1cLe9jwC9h7W9E2mu9B/zwu79/P
NntXRqATwjA8Fe6ASTvmZgDbRyg/LsmpX7zRTG5mJKF+AjAoC6HLBtRFauHbkipI
+6WivUDej2DsBwiL3k9XPtofyKuK6EFRoBiRWhrCSdT7KUFR9Wl7H22V3hfofbce
ASRDTH+zR/R2uEToPOY6rg590Je/XigFbFZA3AH3ip4F3xtIQCMybAucE5Yw1kfu
b7QqWhzicoJhy9ij15E92F44FMJ8Df+seEPYxPKZsyZ81x4Oxde59pUl1pwYJJZc
CEI6gYTqC5+110F4a9MYlHMkf/O4fjvAexc8n7+7Sm5FnxNvST62rQED4FdmPDR/
6Xmi3C1mCkaTfjhygTSXMPsghI9rXZhBXc0O/NqZrA0XXGS+HCbC9yQqTTANe6at
K7HsdmRrcMNVpXnQQYueAwwrs1L/1dc1bUMEO8I1Z2TiJCjdEGva3hoK46XmYUff
Ke/Gh/z9nNMEIzVudM+gNiKRAXhkvYYYo6VDm+d4mLGSnX053cxc19NhXnw0Ws/c
tz4l9d3ymTGEFVnl6Hzg
=+oIw
-----END PGP SIGNATURE-----

--jt7EHN8kmSCh+bhe--
