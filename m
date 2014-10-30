Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366AbaJ3NZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:25:05 -0400
Received: from sauhun.de ([89.238.76.85]:35941 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727AbaJ3NZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:25:02 -0400
Date: Thu, 30 Oct 2014 14:25:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Xudong Chen <xudong.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>, arm@kernel.org,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org, Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Subject: Re: [PATCH 3/3] I2C: mediatek: Add driver for MediaTek I2C controller
Message-ID: <20141030132537.GB23852@katana>
References: <1414561058-23803-1-git-send-email-xudong.chen@mediatek.com>
 <1414561058-23803-4-git-send-email-xudong.chen@mediatek.com>
 <CABuKBe+RXboBEZD7Bu_kSbVwiapJJcAuuw_wo=xw67osJWJ20w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <CABuKBe+RXboBEZD7Bu_kSbVwiapJJcAuuw_wo=xw67osJWJ20w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > +obj-$(CONFIG_I2C_MT65XX)       +=3D i2c-mt65xx.o
>=20
> As it works for mt65xx and mt81xx series, better rename it to i2c-mtk.c

That is a bit too generic IMO. It is likely that we will see some
totally different I2C core from MTK in the future. Plus, it is not
uncommon that a driver initially for SoC-X supports SoC-Y, too.

Thanks for pointing out the other remarks.


--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUjxRAAoJEBQN5MwUoCm2qEIP/iyFdvDPmtc3hA2x89c+dEe9
lJ44z7RbYhP488vZedyRcbCIy1/vcs/YV9PxNEtYKsqKlVlLQYh7qEVhSL1JrZVh
uOggnxFxBQeC4lBpHWOh5ZyucOGhhKT2433ifTkmrLK3dXVEvqEQKWzIltiPBUZo
Sd9kG9/9otdPEJt3xGOjezb1oOG8ixSQM0OPQACDZDK/zVIkKsT8SoEkJrRwmj9g
l6GOM4djaTesHqXtxyPBTTM72eJFIeFW+7SsxOHHlj81zMx/6sQuFTZi8J8amKg+
F5kyDAOM5LpvVb1aXDE/iCDpdnPidTtNBcv4M73wH84hsDrOR748/nZM+J6JU514
127KqWwEWtduu1OA60F6jLOXOgdnjqndCDzBn4SLD4DB5ESEbfE8WYEREcM0TN3e
/+pHa2TCThEaz2HN80zD7ch4w3MSP87hKRApyezkr4tT7g1m++IzJ0Ig83S6hgKU
m+gBETIbx0MIXCFKTHJoWD21muXs432/OItGA77uMep8dza2PDzhQqMRf2dDCG6B
CZW4sKkRIDqaPpW01XutwiLf5s5EZI6v9xdyE1Ymyq1m1E0BOjXgG8On8TLUTYWQ
Ph2cw0xIW6eHwJ0Ysh5bpZ3IJYzdQIXN2AmRRMcsl/YhgudqBO+yBYb+eGk6MaT2
hTBYkLnwdp9RqNP/FhXV
=mkvs
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
