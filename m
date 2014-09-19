Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbaISPjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:39:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317AbaISPjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:39:06 -0400
Message-ID: <541C4E14.9010000@nod.at>
Date: Fri, 19 Sep 2014 17:39:00 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: sparse@chrisli.org, Mark Rustad <mark.d.rustad@intel.com>,
        linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 5/7] signal: Silence nested-externs warnings
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>	 <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>	 <541C4D57.9050507@nod.at> <1411141042.2513.3.camel@jtkirshe-mobl>
In-Reply-To: <1411141042.2513.3.camel@jtkirshe-mobl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TOrcJmsDrISW6q1ooOcilVRpNO1IIObvi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TOrcJmsDrISW6q1ooOcilVRpNO1IIObvi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 19.09.2014 17:37, schrieb Jeff Kirsher:
> On Fri, 2014-09-19 at 17:35 +0200, Richard Weinberger wrote:
>> Am 19.09.2014 17:29, schrieb Jeff Kirsher:
>>> From: Mark Rustad <mark.d.rustad@intel.com>
>>>
>>> Silence nested-externs warnings for these, as these nested
>>> externs are truly wanted.
>>>
>>> CC: Oleg Nesterov <oleg@redhat.com>
>>> CC: Andrew Morton <akpm@linux-foundation.org>
>>> CC: Geert Uytterhoeven <geert@linux-m68k.org>
>>> CC: Richard Weinberger <richard@nod.at>
>>> CC: Brian Norris <computersforpeace@gmail.com>
>>> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>> ---
>>>  include/linux/signal.h | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/include/linux/signal.h b/include/linux/signal.h
>>> index 750196f..e68ae6b 100644
>>> --- a/include/linux/signal.h
>>> +++ b/include/linux/signal.h
>>> @@ -67,7 +67,9 @@ static inline int sigismember(sigset_t *set, int _s=
ig)
>>> =20
>>>  static inline int sigisemptyset(sigset_t *set)
>>>  {
>>> +	DIAG_PUSH DIAG_IGNORE(nested-externs)
>>
>> Do we really want to clutter the source with such tags?
>> Does this even build? i.e. how does gcc know to ignore that?
>>
>> rw@azrael:~/linux (ubi-wlcrash $)> git grep DIAG_PUSH | wc -l
>> 0
>>
>> Thanks,
>> //richard
>=20
> See patch 1 of the series.

I was not CC'ed...

Thanks,
//richard


--TOrcJmsDrISW6q1ooOcilVRpNO1IIObvi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUHE4YAAoJEPmeIjfg4Uaa61kP/AzwwgHhL7uWhU0TRrwlVZKT
Vi/81lLaKUntIkpjbGLPkpR/vN5hGAVlYt/SpzyCw+hffRz51FZa0yWEgZ07g5tr
x2guQfNX5dgfYjW9SRSjSCaHYcCTNb/fu7rWZCdvbmQ6e0zHHf4px2EzA/k6hEZs
+f9/GxwB5nJaFBilIvGfppKTd+Mg+sVXgq8pl9Dxf1UWZae8AH5Nk92FvPprwsh4
e5YMxj7HnbfDIpuGamMyWgi9rzTjcC8DEcbA0S4BYA/Jtn0paJ1CY++lg1FRtKus
V73bNUtVDN6s28gLcCqyVjOH8YtYMr6ekUo75hsjgkaCw8gBuTyGIaovvQQhL/A+
dNmBrHB3/rg/SHlADKW6tzEGi9bGqO1Ouhw8w2Eub4xaXmfS1Rib1DTZPVRUDKXa
UC/OBghKXXxmC2IzljUDm4ineyjLpYN69i/maWyhI/IHdk64gm7f2ORGVSan5LrW
mm08rbAHzV/GsPCBRyCSQ34VIXTrpKVxA4bHJrERMxij857Qqj7xds8WnPI1qe3n
I3v8ra9O1gRsFXS7kbNyyXYOQayYOcie7NDnb0b3jQL18JOYCqY1nqcZ6XIkzST6
6lFY8J4eQwiangCT8XxRUZbsn3Qvu69qS8uJ2KBC4mOReb0vfT+QOdab/tqq4RkX
CPhcvxRYOwP4lRKzHzdW
=Af+j
-----END PGP SIGNATURE-----

--TOrcJmsDrISW6q1ooOcilVRpNO1IIObvi--
