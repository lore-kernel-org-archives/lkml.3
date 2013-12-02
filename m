Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3LBNy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:54:57 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45930 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3LBNy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:54:56 -0500
Date: Mon, 2 Dec 2013 13:54:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LinusW <linus.walleij@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20131202135452.GI27568@sirena.org.uk>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
 <1384859269-19801-8-git-send-email-lee.jones@linaro.org>
 <CAOesGMiu16f_L=cMWFCNZMjNB9tBK-2LXn02k-R7FhkkgR5-+g@mail.gmail.com>
 <20131202101256.GA29373@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tdQcld/J3/3kIpyY"
Content-Disposition: inline
In-Reply-To: <20131202101256.GA29373@lee--X1>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 07/10] ASoC: ux500: Store DMA data in the
 DAI differently in the pdata and DT case
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tdQcld/J3/3kIpyY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 02, 2013 at 10:12:56AM +0000, Lee Jones wrote:

> It's actually my fault. I had two patches round the wrong way in the
> series. The imediately subsequent patch in the set fixes this issue:

OK, so what do we do about this?  Is there going to be a revision of
that patch adding the note about not using the autoconfiguration stuff
and what (if any) are the dependencies on the arch/arm changes?

--tdQcld/J3/3kIpyY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnJEpAAoJELSic+t+oim9NkkP/i+Rc1fQnypUrmi35VrerqMb
VV394BOw8NQA+eqqJFkXNMZUdzZzhvSFeUNZtvLwy5CEb0nGbiqoxIglQGfk/wNp
fnAO5LGNcH3wn0bZaFKbU9SIqgFzZMVRB830QLgQeKpu8jfNHbmZQ65H2U8l0+n/
j8cxRABz/byEWJbsxe7Dvd78p/r4XmoP4e5MBydrgEKJrt4hEG1V1GuQ4yLxJSvT
EeOmIpZD6MTSdYn1oERFJzPg21lkrD9PXFO6edE6Yl4sRDvyMV4ZXn/Xobq+h9Ig
vDZICkT5pwCfR0q9SVhkp14L3pz+TfbGmw5SDK5lzz96Z3FUKbdGRfvz0VcLoH44
0lFWGHSy5lLp7/uofnDE5gx8LVv/cD+LP+phnXzRk8+0/kJlyqx3unExgLOJ8uxM
pH/T6K6B8aRXAv76lY/QFrsa1QY7Q5C/V6Rxr19J6JXVY3XNzMJLQ4AgkkGS4uEx
0glr4jFsgZ3r8fNw8gV3bJwpYejLD2LrJ4fZWmMHnMMCkYmYS/j6vbKpWOSgXgKS
Ta6lamnMa7jVPLMGUQkIf6fY0cdmM1GuMx/XQ0lt1z8W1rUjiF4fu2glK1JjfaVq
kOhtfHqiE2O2xcBuh4MGaajCg8md/NDzIHLpqhfLQWhkc9PYO4tYVjryOwuktCqJ
xG2wOgP7NfXN5mzxs+AZ
=NWay
-----END PGP SIGNATURE-----

--tdQcld/J3/3kIpyY--
