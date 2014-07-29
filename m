Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaG2LQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:16:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32983 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaG2LQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:16:44 -0400
Message-ID: <53D7825C.2020900@ti.com>
Date: Tue, 29 Jul 2014 14:15:40 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9] video: ARM CLCD: Add DT support
References: <1403610911-31491-1-git-send-email-pawel.moll@arm.com>	 <1404824767.21897.7.camel@hornet> <1406023366.25343.44.camel@hornet> <1406631987.17155.0.camel@hornet>
In-Reply-To: <1406631987.17155.0.camel@hornet>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bVRbbePG6nEdxevRqOVDUhKnmgQaHteVx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bVRbbePG6nEdxevRqOVDUhKnmgQaHteVx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 29/07/14 14:06, Pawel Moll wrote:
> On Tue, 2014-07-22 at 11:02 +0100, Pawel Moll wrote:
>> On Tue, 2014-07-08 at 14:06 +0100, Pawel Moll wrote:
>>> On Tue, 2014-06-24 at 12:55 +0100, Pawel Moll wrote:
>>>> This patch adds basic DT bindings for the PL11x CLCD cells
>>>> and make their fbdev driver use them.
>>>>
>>>> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
>>>
>>> As two weeks passed without any further comment, I'm assuming that th=
ere
>>> are no more obstacles for this patch to be merged.
>>>
>>> Tomi, will you pick it up for 3.17, as you offered? Russell, if you
>>> prefer to take it via your tree, it's in your system as 8005/4.
>>
>> Ping...
>>
>> Tomi?

Yep, I've queued it now for 3.17.

 Tomi



--bVRbbePG6nEdxevRqOVDUhKnmgQaHteVx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT14JhAAoJEPo9qoy8lh71sUQP/jKPnLxnzJq8fzpuEeIGj601
vr11tla+Ih3Xb9oXBwwhomrsvX1sf1MbwTlQrSggdYj47ZkSXC/cM8SYYJuzTZX9
v2Tyv3HnQ62CP9JenfUh6p0CTOZlnFp0VaWRCudHPT+4CamtGf1NfV4JV0Aop0kF
1kHlZt0IDYUJOVQx7oVWvGwJ9sljx1cfePenKw7z6CZbK0UyU5Vu1/eCCQO0s+5K
kJ7IsXlFCAhWPkiy1sZqfutId5zFeO0IHG3HNllmleh9juE6w9pvhnbdsyaTEIM/
L5jZzWAWfbHJtQZe07tA73iDlqWueI5PFdeILFBqiU/umMBmMQmmxNby0oLqOd6K
wZVoGdihQ7yYKEN3ZOEeP58MBkYzXtJJ2Jj/jJ5RV8x/Gj622PHME7x/J6BOnMvK
8LaTtGnl7jul/qgr5DCcu5fU9xw2148VwuVSMd2YPsp4x0d8TaA3q1X+skYBvisK
2KDEVEOKIuT4dkazBU1oocy7nALOKATzbHr0hub+f8+ZO1lwBnRDSEStS9LwMqmT
zS3Y7j5Vz/xgC6kpVB8REG7ZfBL+DnPMePKFFmGE4uH+ryYrPCm21TWgCrxpk5Xp
o11cB9hBw5cCk901vFRfB/gAO2FoRbp4ufKh0usT27r2FaUM9cgqTvTCEX2UiZPC
qO/J480Qe+wW1kJTc2FH
=IPAQ
-----END PGP SIGNATURE-----

--bVRbbePG6nEdxevRqOVDUhKnmgQaHteVx--
