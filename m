Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaDYOQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:16:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45140 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbaDYOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:16:24 -0400
Date: Fri, 25 Apr 2014 15:16:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>
Message-ID: <20140425141609.GO12304@sirena.org.uk>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
 <1398264640-12122-3-git-send-email-k.kozlowski@samsung.com>
 <20140424124803.GW12304@sirena.org.uk>
 <1398433531.30695.3.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RI+P/CiYqhD6quxl"
Content-Disposition: inline
In-Reply-To: <1398433531.30695.3.camel@AMDC1943>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH part2 2/6] regulator/mfd: max14577: Export symbols for
 calculating charger current
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RI+P/CiYqhD6quxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 25, 2014 at 03:45:31PM +0200, Krzysztof Kozlowski wrote:

> Thanks for the ack, however this patch already got it:
> https://lkml.org/lkml/2014/2/7/640

If something has already been reviewed or acked you should be including
that in reposts, otherwise nobody is going to remember that the review
happened.

> I need your ack on the fifth patch:
>  * [PATCH part2 5/6] regulator: max14577: Implement SUSPEND mode for
>    MAX77836 LDO-s

I'll get to it at some point.

--RI+P/CiYqhD6quxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWm4mAAoJELSic+t+oim9iWAP/ROYV+tIgjMyQWsT/ilyFjDH
/n/r23tS04B5QOq32t6e/7WV6SvAuW4dGqDrxIvmCc3qs71ktVDpaEAMSia8cEsz
OKNLnx0bdJIZgQBCqsTeYhFe4lmo5OpIZBAsGR7GtGTKw7UnRslDIY120ZOLdJLt
iB9tBiCQFJ1nyti4bJZk+DVR/UrQa01YGL6vpfbFjaoLoJwQiipvzkvwPENfD97d
85k9AJWlDbVSBRKumOVLQFAFximjQgehgHWYztQTSWj8IBxps6jrylVZp81xjkiA
xZ2fVQ87YKEK0pm8Yxq5uYVRiM/LZRUQtDbHempv5Qr4GWjixLI/AgMSp3Hz/vr4
/JjYu3VTG3I/4p1TuCYJy7y8bSZV9rfXdv+XdnLrCM1LGLenS0+hhyZnrPFFFIUi
l4IE2PLXxyaqEqzz4kaDk/EeU+7wXwn/hZg6esnunsAWyFT1WMDNDfV+ndPLTW0r
yKO6k9Gvc8FGQtqvWgsuhF7NLpIz8bp7f5zJZH3vh1h+nhkUZTMCKY04350UO17F
x5BmozLg+6x2b4vffrkaxoy86feYvv9CEWxrT5qYNUdrcAU+KDDHpydLjHykAf5m
nRb75uHZYVePd+Yvez/JzgZfXrLTKCwghJm+VWXbS8fcJKyqo2mQLQF8CCm1nINu
anEx+q0bEJ0xpDgAHuPs
=8y9C
-----END PGP SIGNATURE-----

--RI+P/CiYqhD6quxl--
