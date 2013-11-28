Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3K1V0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 16:26:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3K1V0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 16:26:51 -0500
Date: Thu, 28 Nov 2013 22:26:45 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, s.hauer@pengutronix.de, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Message-ID: <20131128212644.GD14689@mithrandir>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <1384220218-12716-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2013 at 09:36:56AM +0800, Xiubo Li wrote:
> This adds devicetree node for VF610, and there are 8 channels supported
> by default.

By default? From looking at the driver code it seemed that the device
always supports 8 channels.

Thierry

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl7UUAAoJEN0jrNd/PrOhq6sP/2FunsepMC02RZgnhH/wtwXI
bTHXcMprlEnqOm3aNBujnTsbpTP+1xmHZAz08V9NcPiwWm/UmlPW5ZKBk23ToSsh
K+hU+hkkuR1sZkrxs0sWvCb1a382VghMI8rrNv6gmV6B/t2F2Kps27H4Em3Ez8Bh
r0ym8uAgkLt5CrL4otBG++i3bgGN83T9JIDutNz9K2xlW7IPUEkKWJMi019g7Clv
9ouXJx9uiAPXQHXK8Q6F9rScyVrU1le9qMbk4uNqnqnD6fxE5pWQQYybFkE0oC2T
f4ePwOIZkaf6tyU2zOT63WBs+rOsddtx8581mIzuApcnErgM0UxRjeXxxfwhbynD
IdaoWJsA0GAH+ah13xsXCLPdDGNIM/R8BIF+x8579gXs4AgRaYoN1o0a1gqjY/05
8cqKsDfr+016fyyOCVXSMElMWViS1ri2OtJ2D63MoNc1efVa8Sq1HRajDuip4wgt
4cTa6HRn9X21xpJFoXHSfRLXQokgr1tw4952qVLmiD80EBPZq0bH7F3wkoNYfrEq
AX5SG0FTJWwPcq++0rJ4+h8d47gJR9oJ8OEE2MEH2nUnl7dAHHAVXBw7UA2DWDdZ
TdDvXO+ilRX7JmlgJk+C5Qmfa30dLoyozNBltYkXpQIOdvxpQn6CCMmCu/WRDUjI
mFGz0Zm4TaT5992QRb87
=NDfc
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
