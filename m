Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3CLTgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:36:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51404 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289Ab3CLTgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:36:11 -0400
Date: Tue, 12 Mar 2013 19:35:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V2 RESEND 2/2] regmap: irq: do not write mask register if
 it is not supported
Message-ID: <20130312193558.GE19942@opensource.wolfsonmicro.com>
References: <1362673997-6762-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V7LzxcfGKRikha15"
Content-Disposition: inline
In-Reply-To: <1362673997-6762-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V7LzxcfGKRikha15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2013 at 10:03:16PM +0530, Laxman Dewangan wrote:
> Ignore the mask register write if mask_base is not provided by
> regmap irq client. Also assume that all interrupts are enabled
> in this case.

> This is useful when device does not have explicit interrupt mask
> register but control the interrupt enabling/disabling by other
> mechanism like irq type/irq edge registers.

I would really expect that the operations that mask things would be
failing if we can't perform them, things are going to get upset if they
get interrupts they thought were masked.

--V7LzxcfGKRikha15
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP4NkAAoJELSic+t+oim9OjgP/2Gs+PZSwyE3J6HJBilnVkkY
4jAS1hnrhInT+gA5mkzuG9bGvDl5oW6276tSMhHp2pUrX+l5AtfQY+bttfLZRpXn
/nsG//nppeB8drdREuBQAZ/I2iDItJ5corQb4MnLUL0ScqUtx5o0bUlsByuWYr4p
PIBGO4/7qQH6hLN1fX85QFAPtk12Mky2aMMxg6urPMjJNbEy20sljlzhtBPJ5YWm
Yll5ouTREf9dlxbcDD+ApCuv+Yl1w0v7DuPTDfgZwi839GIwivHR8b9+KVJd5pxh
Xch14tpIqtNMuleYHbaBYb8dzDf+qikMcdOi78V1ltTDNH5L0jbcCG4d/OW+29mq
wa0uC/vbmAssBgmRCZoUbdhvlbNBicQlLUgmZsWVI86wCH8cI9OdF0ficulrCDD1
2S2EUZP/xdwzYU4aCQLHJB89O7cv+/m9CTSJitps8EfUxV6OCigJp5T4NaETr3Rf
XSeFUURvu7uXVoaGoLcgyJql2n9r5ByeVyvvQpHpJfHTNTQ0csjzG9ER9Jy59Ay1
fkS6FU4/bXHp3r4+BSwCXUEaNDTHj8eMuLFEcA68UibVxmvJzWnQPGwvNMrOQcQx
M2VYu8tGuKnKzkNgoBZ1aL7LQpLIIGu+s/zE2j1Sz8LQWV6pTeRj8fMVs3lbIpJP
TR5/tCkmOir9aVTOfD/z
=dCqV
-----END PGP SIGNATURE-----

--V7LzxcfGKRikha15--
