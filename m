Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3AZHWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 02:22:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49216 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab3AZHWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 02:22:11 -0500
Date: Sat, 26 Jan 2013 15:21:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 01/10] spi/pxa2xx: allow building on a 64-bit kernel
Message-ID: <20130126072158.GI10580@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9ZOS6odDaRI+0hI"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-2-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9ZOS6odDaRI+0hI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:24PM +0200, Mika Westerberg wrote:
> We are going to use it on 64-bit kernel on Intel Lynxpoint so make sure we
> can build it into such kernel.

Applied, thanks.

--/9ZOS6odDaRI+0hI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA4QMAAoJELSic+t+oim9SNAP/R+OJA/h1izm6B9eLGQcNowO
+dJxxiVgDxpw+dht9O6ayuvPXeDXOWWAtY/pOvQFAZXIw76+lIVkzHbk/4hQMQPp
c3HwDudOk1bRTef0Mh/Gs0JCANF9prFka6kYTeYxpJovgbzw/x81ObS7US7l3VOP
vw1s7u9fVhnUZ0z/6HN6vb1uqaN2DIq3siSGggDi0snVG9sSFsb2I/pTNYhG4L1a
M0c1IOVc7kCdR/RD3fJ49SrLMbrZemMVBOz9djJA5dbmREZn61GXv120ST+04hiK
bvSe9sDuk+rj5HV3HyFWisq+tOoQoOTzvfsDYUNuS6bwY5vO4wTHbpdy93xU+Pr4
3qAwbQnecTyDCci5RjCnanAf4VxZu1Xpr6B1yZMeq9IBj7s7JI8qVxblYHwwicTI
69ccr19nTfeSAcuiBmlN9GpBFI0+ov7C0HcwT5l0DBHlYgjPISTbCmxy/qeInlKz
e4ZdDzTc3ioeaWiCy/8he71xs0UiPJfho/NN9pocJf41KJg+jYQsN+/IaDQ0m7Me
nR5EwJc2HVkUJKYbZnEWk3obVW4N8M1KvebR6IHiQE9hBEFkMUr0dFaTDc3reMEM
reaMOmrWqiDF0qQxvyNMjsyjSyPFnprW/GRMFm8IbLCAOVaQNUsFj+JqHWiglEjj
tlbwst/Uh93KcCw9E8VC
=T3kK
-----END PGP SIGNATURE-----

--/9ZOS6odDaRI+0hI--
