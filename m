Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3EFKev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:34:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42574 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800Ab3EFKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:34:50 -0400
Date: Mon, 6 May 2013 11:34:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: wm831x_backup: Remove kfree call for
 devdata->backup.name
Message-ID: <20130506103448.GD13472@opensource.wolfsonmicro.com>
References: <1367647075.4394.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <1367647075.4394.1.camel@phoenix>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 04, 2013 at 01:57:55PM +0800, Axel Lin wrote:
> devdata->backup.name points to devdata->name, the memory for devdata->name is
> part of struct wm831x_backup. Thus remove kfree call for devdata->backup.name.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRh4dAAAoJELSic+t+oim9pI8QAJZRPqkClgqByQgDZZ5s1Cez
kZMwHdWXA5M4PT7dljkZf89Iz3sAFjn6M0ZvBdy61pAFQapBrzMqNLxjOH8tf/Qm
v5Y0GlPxMdWLJDWCHSF2lctnhbn4LfkRqgLoJARBayKG+egV8Wgbdh3fSMMYTsh8
/Tsk0u4Y0bq29x6B8VF0kykocVN+O589eHxQoxtI3V6gF3t3JDkO1TwDlKf9voEy
+j9/4IxOsYJ5ZGOyNeQsThi5N2YVtxANRGmBizS8Ls4l0/v+qPGPeyenwitKVuqi
WoV40P4HtN++wxyZjfjeYcT56WPCS1R5cmevpvMsgIuVEiv+8HwoE5pm54BknQgF
ZPGTJRGmZCi9fGvzsPgYbynlwoBIENGPAj4lVu1Xh21yLuf9sXu2xpu0LLKEM7GM
16OJ6JVbw7/PeTnpFb6KIsDvnXGNIeLRhaKq4ZGnxUjEBPFubhtNl8ld1zwOo/wH
Qd7FrBeHd1dmzMjoSl92mnWE4p8554wegwnps/dKmlOkqsyIdoVDODzo7frvoJwg
pzFnLQZN0YTzgCdYtFPlZLIrw0kPDd9pxBLTWFTOPs4uHNeXA8EOeNvVs2aTmyOC
vVbJFvtAb3de9lXn2iLhyZbOwuuP7xOwO/Cfm2FeU9rdieGvTo7+IuvycaiJGJNH
lUYSAWODS5YgtEDBIFR5
=1lHR
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
