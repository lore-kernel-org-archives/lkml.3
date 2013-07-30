Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3G3Fqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:46:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55418 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab3G3Fq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:46:28 -0400
Message-ID: <51F75310.80403@ti.com>
Date: Tue, 30 Jul 2013 08:45:52 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] ARM: msm: Move mach/board.h contents to common.h
References: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org> <1374699274-18388-7-git-send-email-sboyd@codeaurora.org> <20130729202031.GA20694@codeaurora.org>
In-Reply-To: <20130729202031.GA20694@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="oSWxht7BdBMDRN90cjdRcajElqLPj08jB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oSWxht7BdBMDRN90cjdRcajElqLPj08jB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 29/07/13 23:20, David Brown wrote:
> On Wed, Jul 24, 2013 at 01:54:31PM -0700, Stephen Boyd wrote:
>> The contents of mach/board.h are only used by files within
>> mach-msm so there is no need to export this file outside of the
>> mach-msm directory. Move the contents of the file to common.h to
>> allow us to compile MSM in the multi-platform kernel.
>>
>> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>> drivers/video/msm/msm_fb.c             |  1 -
>=20
> It'd be nice to get a framebuffer Ack from this part.
>=20
> original patch:
>  https://patchwork.kernel.org/patch/2833029/

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tom



--oSWxht7BdBMDRN90cjdRcajElqLPj08jB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR91MTAAoJEPo9qoy8lh71W3YP/j9eg2vIUmATSMZYE4qsALEq
/0Cdd9WlKmomcoSDkhXFHs9WNoqyAMUluKDdAlqMsKlf80KgmqH4+XZYmGYTNkL1
VE1XZOPNLFclItjVbrVdxJu1vjnAp38GoETpZGAuU8Sg0jXqOONsndKOjXiLGlVG
HrZBFnFvIEVg0BU2SHqHvVSbPRON1t6OcvfR83H0KE4OoF39WvFLgqKEAjYmuAdc
8cCmJOqgS3jHZMy1TB9LfWWuXSxOfbZZMvyPvHcKxX5i/VGwpNQRrAxU9npE/wxz
LPLeqfa+V+IV3tmBKyHHjCvYX0suLda8No/Xcwhgiwj5pD0771VenCE0s+N81Mkj
YhpMLTAPh1pH7VW8B+PVqBetqi2EvakCzTrlQRKckt1ddo33csyj1DjiDWXJX9FB
Ie4TzRW2MAfA0t7roUvidtHAvID/zkc3EojfuxBKJnHVXBJSb4kBM0D1UgR3BYD8
3kbWq3ZObTEi0XY+dVDBCWFXSz3C0Qa0GnRRNkfY8NtoArdI+otaggDiwAxHlBvp
ScjHHae9zOsoR29xOezRQQpI45Zv6ZcEaSilmgnv5Ye6dI17atALZp9hPpTdXDaS
ZoLxCsfFv53jfbxSJQ882/ieZHLXxB4MKEunvcLvzTShYJ4mmxS6RVr80SAIV3Ts
vT7ov9h8C1xs5J5PvbX4
=Fk6k
-----END PGP SIGNATURE-----

--oSWxht7BdBMDRN90cjdRcajElqLPj08jB--
