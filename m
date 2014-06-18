Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaFRXYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:24:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36818 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbaFRXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:24:51 -0400
Message-ID: <53A21FBF.5090806@wwwdotorg.org>
Date: Wed, 18 Jun 2014 17:24:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com> <539F4D44.3070309@wwwdotorg.org> <53A03186.3040703@collabora.com> <53A069B6.6070902@wwwdotorg.org> <53A1CB23.5090307@collabora.com> <53A1D089.8010605@wwwdotorg.org> <20140618220343.GD26514@mithrandir> <53A20E02.5050900@wwwdotorg.org> <20140618231410.GG26514@mithrandir>
In-Reply-To: <20140618231410.GG26514@mithrandir>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="I2dPCOm6FCrSjaWnNTXfrE9fh6llVORAp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I2dPCOm6FCrSjaWnNTXfrE9fh6llVORAp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/18/2014 05:14 PM, Thierry Reding wrote:
> On Wed, Jun 18, 2014 at 04:09:06PM -0600, Stephen Warren wrote:
>> On 06/18/2014 04:03 PM, Thierry Reding wrote:
=2E..
>>> From what I remember, Mike was fairly strongly opposing the idea of
>>> virtual clocks, but what you're proposing here sounds like it would
>>> assume the existence of virtual clocks. clk_set_rate() per client
>>> doesn't work with the current API as I understand it.
>>>
>>> Or perhaps what you're proposing isn't about the individual clocks at=

>>> all but rather about a mechanism to express constraints for a set of
>>> clocks?
>>
>> This doesn't have anything to do with virtual clocks. As you mention,
>> it's just about constraints.
>>
>> One user of clock "cpu" wants min rate 216MHz. Another wants max rate
>> 1GHz. cpufreq will request some rate between the 2, or be capped to
>> those limits. These set of imposed constraints would need to be stored=

>> per client of the clock, not per HW clock, since many clients could se=
t
>> different max rates (e.g. thermal throttle 1.5GHz due to temperature,
>> CPU policy 1GHz due to the user selecting low CPU power, etc.)
>>
>> Similarly for audio, of there are N clients of 1 clock/PLL, and they
>> each want the PLL to run at a different rate, something needs to detec=
t
>> that and deny it.
>=20
> I'm wondering how this should work with the current API. Could the cloc=
k
> core be modified to return a per-client struct clk * that references th=
e
> hardware clock internally? Or do we need to add a new API?

I would assume the we can just change struct clk and hide the details
from any driver. Hopefully only clock-core and clock-drivers would need
any changes.


--I2dPCOm6FCrSjaWnNTXfrE9fh6llVORAp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJToh+/AAoJEJuNpwkmVCGcEQQQAIzeqtCG/DISo4rxAND+3zpE
U7yQJPFAJ7TXQGPygiCSBUNCPEhN0uhX7yCh8t+BphJdN180YYvHs8S2pbxsxQgq
rtUZcAXmD6AVA/n42ptWR6R+Cg90axWhGRsVMYGQDuzmS+ibz1Ra3vAHe7jxOFPC
g8p3IaXCBB5l0vkRXBTd8KXsj5jtjP2qq0YYtMyGNoRiLgip0fOLX9qEsxMVdaEn
I5FCd4qObGu9FEb2h0T7P4dwPqVcP/5yxQB7gpWfZQsPZNLoEBRPQJmCkZJafBXB
lM8DZGjnwvqBLDKjQ9TTP2gOq5mNmKmoLWQTKRfGJe3j44ltVd6zyMKUfPXcSCT4
KLb/jyLPK6P1mTc1qGqKUT3x+hlAIN8f+pI+mGxurjVjzQG+Msilkt9kVLY4mjgA
f5p0bBlBi0fteh9hAuiJJq2Td/WLhMib2PtodlQrAVD8HD6STqg1o7uY5qghXCGD
EsVfNFfxPEl6caTE9dgFpTeQX/HyO8g+bJ6MCX0r/eSx0Vg2tRE/dcviLAnC4gI1
B4QXJgE3ySNjFCnYrv6bQrf0Nq5+0ZzD1WK33T2hYuLyyR8wGkny/lAzL20lqRmH
mr2RZQv/htsHZOMMEbqsKUgf3h3i7iL6XQQm3up8Juf72/RzjEb+WqnoXY0OXUGK
vvu0XmhibyGb1VZS290+
=VeD4
-----END PGP SIGNATURE-----

--I2dPCOm6FCrSjaWnNTXfrE9fh6llVORAp--
