Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbbA2Ke4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:34:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60619 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbbA2Key (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:34:54 -0500
Message-ID: <54CA0CBA.6030900@ti.com>
Date: Thu, 29 Jan 2015 12:34:34 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, <devel@linuxdriverproject.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v2] hyperv: hyperv_fb.c: match wait_for_completion_timeout
 return type
References: <1422197222-7967-1-git-send-email-der.herr@hofr.at> <54C62D07.3040603@ti.com> <20150129093839.GB23666@opentech.at>
In-Reply-To: <20150129093839.GB23666@opentech.at>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="aG4kRQ1HqL8vvduNhbRM2jPhmD9vB0A0d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aG4kRQ1HqL8vvduNhbRM2jPhmD9vB0A0d
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 29/01/15 11:38, Nicholas Mc Guire wrote:
> On Mon, 26 Jan 2015, Tomi Valkeinen wrote:
>=20
>> Hi,
>>
>> On 25/01/15 16:47, Nicholas Mc Guire wrote:
>>> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
>>> ---
>>>
>>> v2: fixed subject line
>>>
>>> The return type of wait_for_completion_timeout is unsigned long not
>>> int. This patch fixes up the declarations only.
>>>
>>> Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=3D=
y
>>> CONFIG_HYPERV=3Dm, CONFIG_FB_HYPERV=3Dm
>>
>> Why didn't you set the text above as the patch description (which is
>> empty at the moment)?
>>
> basically because the one-line is sufficient to understand the patch

You didn't have one line, you had no description. Patch subject is not
patch description. In the minimal case, the description should have the
same text as the subject, but usually it's better to have a bit more
text in the description.

> and the rest of the information is not relevant for the git log but onl=
y
> for the review
>=20
> if you think it is necessary to understand the patch I'll move it and
> resubmit.

Well, a good description is not only about understanding the code in the
patch. It may contain information like which platform/setup this issue
happened on, are the any possible side effects, or whatever might be
relevant for someone looking at the patch years later.

 Tomi



--aG4kRQ1HqL8vvduNhbRM2jPhmD9vB0A0d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUygy6AAoJEPo9qoy8lh71NWgP+gLLs+7sFxXI+gX1xnRhajkR
iTMCTGHr0yExoFSHd6U9S57x6uPJ+GtxZZMQUMfZbvveg/GEwg/9byXtkR5LrcQk
GmRab0D+T2iB1GdGWszmCm1is2X+kD2ZLwYxYLwoyPtcowYpmPwF8f2eIvQTG65l
qv5z/M3maFcepNFRmAkP/zWRvlPa+g1V1kRXbhcqx1OlylytqyntW1Ms8qV7R6/j
dsOEzPJrx386o7UlYHELRBg1swwuSEbWpPNMQ6cdQZU/97iGy/v5SVu16h0+x3Nd
54Oxrq4drXZYsqrkdLTdphi7XjeYtqQZ1hGGJI5HnRDmp9FhmAlt3i0Xtks5gW2I
WpwVQ+Y1Db7iya1GqadPcd9TABOS7w7+TY0VWeyKn2fCrTcmrCT1BDXVJM46RfwJ
en/Bm94H6eDpRu/lM+ZPyc2MIQhBhjIpn51/XyVsE2d5qPFsbvc2tZAUPCck4Mhf
cnK9Lrf6VXEY0lMe4uL6F1Maoh93El+shZFg9DR2fAk4Krm4u+q05kF1GmtV9bLU
Uk7UL9yoA4ylpXTPBWb7x12CxtMVm3qzNbLsRRjfwd5cDafKgEFBeewtru51QDiy
fI7tjxUnU2tgcQrHMDQUYmm8Qkc6yP5bHvx2qJaOtUqXHJNdcVo1BpqJjkYnGNTs
P2iCKtuaEiJU+WYoZRJG
=A2UJ
-----END PGP SIGNATURE-----

--aG4kRQ1HqL8vvduNhbRM2jPhmD9vB0A0d--
