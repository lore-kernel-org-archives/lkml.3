Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbaJLFwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 01:52:10 -0400
Received: from sauhun.de ([89.238.76.85]:35024 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaJLFwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 01:52:08 -0400
Date: Sun, 12 Oct 2014 07:51:46 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141012055146.GA1310@katana>
References: <20141010072439.GA1741@katana>
 <20141010083627.GL5182@n2100.arm.linux.org.uk>
 <20141010182604.GC6075@katana>
 <2769473.KEN6DZKnT7@wuerfel>
 <20141011165650.GA1263@katana>
 <20141011205527.GA30877@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20141011205527.GA30877@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I missed the one code path you pointed out, and that should be fixed,
> but that doesn't mean that the original patch should be reverted, as it
> is the way we want things to be, let's just fix up the bug and move on.

OK, that is a clear statement.

So, what is your opinion on the original cleanup series removing
unnecessary '.owner = THIS_MODULE' lines in drivers? Helpful? Noise?

Thanks,

   Wolfram


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOhbyAAoJEBQN5MwUoCm2rz8QALApWGKZOOzy3XNzFQGGw3Nc
YZNbz41KX+OxK+cxcTSQbYKXWVRLUdTUf3iewDFOoTr6ggG2Ra2VyX28mLBUxWUy
SXGBOZLQpyNZbsE4KPPjijRInWYtCIrtZofcMkMs72+zWburqkfaQN+sHWnaIqVh
sD+TmWNrJHI+ZVYtUAn2LjBmfdN06uCIHOIYxwHG1xmFTkcoTSgQai8Jby8FM6nj
L8x/Zud92CFqoFLNCFUmdmXEld5hFcGxXgzUZ+fGAQ4MKBxMGIogZWQHLKsjSfJ9
hzQxDnLJ+cegSLFf2n8aIv2hlBzOXZLSLEmq+r7VUG8L9vKK8Wz89FO3x2cbOXWw
ldoOntGQZecQUfJMf2+hQVkcAMfZnLEwK9UdWIwsgVF7sWXa4Z5wW4gpB/fePwUB
Yj8nvpkdqLBwkn+SvxfLgU5YtjVgHk4P9b+Ykive2mqYbqK4LLqP78iho5Jxtcu3
4TBDBrBsdpAgC5ABIQSlHmi1yiEPXurbjkA66PuHeSoKKpwDSGDeD9w8+JHtiWyV
atkDZckWt0a2qo0XD8TqMlPMWSMR/xn6M+OBAvIiRG/uiLfjcidp5kJgd7+V+R+l
Wlg3ddYltl0SjFzxYgtfrVFyKPi5FAkzWIWyUfxzpegmX1A3V/DozRNZkCpZkeqE
fVdKjc1TEHTkvzkfn9En
=xv9Z
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
