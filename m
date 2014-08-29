Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaH2OfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:35:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaH2OfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:35:04 -0400
Message-ID: <54008F96.20601@canonical.com>
Date: Fri, 29 Aug 2014 16:35:02 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Kees Cook <keescook@chromium.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com> <1409248903-19625-1-git-send-email-stefan.bader@canonical.com> <20140829140823.GF3609@laptop.dumpdata.com> <54008DDA.3040701@canonical.com> <54008EAE.2020601@citrix.com>
In-Reply-To: <54008EAE.2020601@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="3ggTPdltkJnGeVeCMlbKCVdTk26BETpqX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3ggTPdltkJnGeVeCMlbKCVdTk26BETpqX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 29.08.2014 16:31, David Vrabel wrote:
> On 29/08/14 15:27, Stefan Bader wrote:
>>
>> Ok, I rework the patch and re-send it (freshly, iow not part of this t=
hread).
>> And while I am at it, I would add the stable tag.
>=20
> Can you use a different title? Perhaps:
>=20
> x86/xen: fix 64-bit PV guest kernel page tables for KASLR
>=20
> David
>=20
I can change the title but would not want to include KASLR. Because that =
is just
indirectly responsible. This is a fix for a problem that always was there=
 but
just escaped notice until KASLR caused the layout to change. This could h=
ave
done independently before.

Or, like I mentioned in the last email, be caused by a large initrd.

-Stefan


--3ggTPdltkJnGeVeCMlbKCVdTk26BETpqX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUAI+WAAoJEOhnXe7L7s6jjHoQAIcRRrQm9DGiCyZCKWomsKaX
LR/y2rZjmSMAyUmeCJ1WcDpLdaL0FOtg/YTQKAFMBbJz/ZqKCDDM9bzIfkFhqwXg
gUzLgpyOJ4gYnCPJYtMiOVb+3w+dD45v8AlBlMZKidvCic2dJ/0dU41cTakA5CzQ
gGD4nQ491ptnqEo+P6W2jijV7o1A5QqvdvxRUGpAZCX+3i2XsHlPgDiRzOJfMvBr
Ce4958S+Zi5pUbdAdb1UDglX3c+glddVFqPTIiVBi1hxeAdK2KQN3pQPknbKRoW/
Yl7V3fZwdoOPpIp5BMIl58nv6dh2lSNEABTi5eEeiSKNygI6tD6PYL0X4KAMg01e
LP/V52HpuvFbcwRrCwl23N3urvE61goVECZY2ISuEwu0vqlstEFHjc3tBQG6kNDN
zoNwB6DZ5FJAX45j2uJex8Q8Po/5uo82UuDryk+xYyILv9Bqc5ws7Z8IWfNC7Euu
V2jr36hVzbY+boLfAmRzLs7H9bpeuE7n8rkbp4V/60jRoNTvVBH4WYwEpmxf/UX8
FoQpuI3jQ29JC3/jzFqeLO+ljRLyRlod/FFziSd2DJG2BEY3Qal/QFXHrKAlgf9r
n2RCxKemS9harPGEZbcNXL19Vu+o9zgHCSojGigY4dQSvqPchknElcrcAd6zQgoK
LV374jfv+AgpKWTjjrPw
=vLML
-----END PGP SIGNATURE-----

--3ggTPdltkJnGeVeCMlbKCVdTk26BETpqX--
