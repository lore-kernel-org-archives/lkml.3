Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3HMAeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:34:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab3HMAeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:34:12 -0400
Date: Tue, 13 Aug 2013 02:34:07 +0200
From: Tomas Cech <sleep_walker@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Tomas Cech <sleep_walker@suse.cz>, kernel-janitors@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] arch/arm/mach-pxa/palmtreo.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
Message-ID: <20130813003407.GA1390@venom>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376239917-15594-12-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1376239917-15594-12-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Sun, Aug 11, 2013 at 06:51:52PM +0200, Julia Lawall wrote:
>From: Julia Lawall <Julia.Lawall@lip6.fr>
>
>Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
>arity of the called function.
>
>The semantic match that makes this change is as follows:
>(http://coccinelle.lip6.fr/)
>
>// <smpl>
>@@
>expression e,f;
>@@
>
>f(...,
>- ARRAY_AND_SIZE(e)
>+ e,ARRAY_SIZE(e)
>  ,...)
>// </smpl>
>
>Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

I used to be happy with this macro as it improves readability.

but ack.


Tomas Cech

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlIJfv8ACgkQ37XrCapiVCNnDwCdH/BQKaGsNRAAJxlrGDlAcBXT
qrMAn1fQhF0dntxwrHzlJj4VpaQOdCRB
=ZwEo
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
