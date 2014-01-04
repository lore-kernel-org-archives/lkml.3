Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaADA30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:29:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45798 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaADA3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:29:23 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] netfilter: remove unused variable
In-Reply-To: <20140103231146.GA23904@localhost>
Organization: http://mina86.com/
References: <1388554039-28452-1-git-send-email-mina86@mina86.com> <20140103231146.GA23904@localhost>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140104:netfilter@vger.kernel.org::i6qmK6MfUzLsjgC3:0000000000000000000000000000000000000548
X-Hashcash: 1:20:140104:netfilter-devel@vger.kernel.org::8NkQfWyFjO9DCcF1:000000000000000000000000000000098J
X-Hashcash: 1:20:140104:kaber@trash.net::2vQGksttX4T2sHV8:0011Gb
X-Hashcash: 1:20:140104:netdev@vger.kernel.org::SvsxB27SaZsnWcYX:0000000000000000000000000000000000000000nIx
X-Hashcash: 1:20:140104:davem@davemloft.net::JYyAfVGMhj9hMD8O:0000000000000000000000000000000000000000002jtm
X-Hashcash: 1:20:140104:linux-kernel@vger.kernel.org::OiXErOm8CXZoh+uR:0000000000000000000000000000000005WEs
X-Hashcash: 1:20:140104:kadlec@blackhole.kfki.hu::egX/CDFVxSBmeHJE:0000000000000000000000000000000000000BcrY
X-Hashcash: 1:20:140104:pablo@netfilter.org::6RPbaPvvRaU6D0UQ:0000000000000000000000000000000000000000008j+T
X-Hashcash: 1:20:140104:coreteam@netfilter.org::zIHgsfpbajPYUJBR:000000000000000000000000000000000000000H09G
Date: Sat, 04 Jan 2014 01:29:13 +0100
Message-ID: <xa1ta9fck2sm.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 04 2014, Pablo Neira Ayuso wrote:
> On Wed, Jan 01, 2014 at 06:27:19AM +0100, Michal Nazarewicz wrote:
>> The nfmsg variable is not used (except in sizeof operator which does
>> not care about its value) between the first and second time it is
>> assigned the value.  Furthermore, nlmsg_data has no side effects, so
>> the assignment can be safely removed.
>
> Applied with minor glitch, see below.

Thanks.

> Thanks.
>
>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>> Cc: Patrick McHardy <kaber@trash.net>
>> ---
>>  net/netfilter/nf_tables_api.c | 1 -
>>  1 file changed, 1 deletion(-)
>>=20
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api=
.c
>> index f93b7d0..9c56adc 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -2521,7 +2521,6 @@ static int nf_tables_dump_set(struct sk_buff *skb,=
 struct netlink_callback *cb)
>>  	u32 portid, seq;
>>  	int event, err;
>>=20=20
>> -	nfmsg =3D nlmsg_data(cb->nlh);
>>  	err =3D nlmsg_parse(cb->nlh, sizeof(*nfmsg), nla, NFTA_SET_ELEM_LIST_M=
AX,
>
> mangled this patch to use sizeof(struct nfgenmsg) instead. That change
> is not required from the semantic point of view, of course, but for
> readability reasons I think it's better not to refer to a variable
> that is not used in that context.

Works for me, and=20

	err =3D nlmsg_parse(cb->nlh, sizeof(*nlmsg_data(cb->nlh)), nla,
			  NFTA_SET_ELEM_LIST_MAX, nft_set_elem_list_policy);

would probably be an overkill. ;)

>>  	if (err < 0)
>> --=20
>> 1.8.4

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSx1XZAAoJECBgQBJQdR/00qcP/izw4odv34p50gZEW8zsBC8L
kRAywMQ88mLEFSHfMInfKgZQ9qKnk5wr5pH5hDLKQLTFvjuXuXCYozh6OG3R7ZYx
DWcXY+tPgrmZRZ1MCj/87dKiP2i5dFgLlxAn60Fk+BtgB+kAldmd5lbMEdsaAJ73
33CxZmP7G1FcCK1LXXWZTfoDmdhDy/mU4gYSimS43970EYvXFukEUNfU3VKNYDsV
76v0uNvY/EQ2GZwBT5qG8YySKAeEvcaFsSKextzeDxu7Q8yz3cGL3GZIqnmFIRQh
svgA3f3X+C1Ab0tv9tc4rd1hkFZzoZLqL3THqfc65zklLGsU+muwuqb8EDpmmiQR
0xHbnxlNU7mAKzXTX2H7oYkMmFwHVjWEgR4F9sWQvcbmfuUTknJ79mpo93eFH1V/
beR/jIvMZxhtVZ+nbIogZEPWJH6JPVam6GC//988KbysTGsqLzzM80fTcakExgol
Ua+jnaUPjr4AW+2rRGGJIw5JfKyofQ4m0etrb4HMP+WFVytmLYRaI1byq35S0ViC
bchKe5W72RbV860I70kUc3T+QTUYd3n+PD9TUDlEDLMeae2WHQMt0Zq8I3cqjg3/
+IJphuIvPuGOkhiiF7soJag1oYQCDy8mlMGghxnOYEZSFUwxBZBuJFb2jx0g5rB5
rEL7ui40/ER6PAhO3VpX
=Yorb
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
