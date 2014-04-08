Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbaDHS5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:57:12 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:50119 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbaDHS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:57:10 -0400
Message-ID: <53444681.1070902@archlinux.org>
Date: Tue, 08 Apr 2014 20:57:05 +0200
From: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: matt.fleming@intel.com, ak@linux.intel.com, viro@zeniv.linux.org.uk,
        geert@linux-m68k.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <20140407173016.GU32556@tassilo.jf.intel.com> <5342E46B.4080603@archlinux.org> <53430646.40507@archlinux.org> <20140407204221.GW32556@tassilo.jf.intel.com> <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com> <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp> <20140408121400.GI5222@console-pimps.org>
In-Reply-To: <20140408121400.GI5222@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Q7Fx1L7nOIIBCfImiBpuB29d1qFQ95SAp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q7Fx1L7nOIIBCfImiBpuB29d1qFQ95SAp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 08.04.2014 14:14, schrieb Matt Fleming:
> On Tue, 08 Apr, at 06:46:49AM, Tetsuo Handa wrote:
>> Fleming, Matt wrote:
>>> On 7 April 2014 21:42, Andi Kleen <ak@linux.intel.com> wrote:
>>>>
>>>> This sounds like the UEFI boot corrupts some memory?
>>>
>>> Hmpf, yeah. I'll take a look in the morning.
>>>
>>> Thomas, you mention you're running in a 32-bit vm earlier in this
>>> thread. Any chance you're using ovmf because that would make it much
>>> easier to track this down?
>>>
>>
>> I'm not familiar with UEFI boot, but it could happen because what
>> I experienced with BIOS boot was an address dependent behavior.
>>
>> https://lkml.org/lkml/2013/9/4/188
>=20
> OK, that's a pretty good clue, thanks Tetsuo.
>=20
> Thomas, could you try this patch? It seems the use of code32_start in
> the EFI boot stub was totally wrong for the case where the boot stub
> relocates the kernel - you're likely to hit this path if using the EFI
> boot stub directly from the EFI shell or gummiboot.
>=20
> It was pointing at the start of the kernel image and not the protected
> mode code.

Hello Matt,

I am unable to backport this to 3.14 for lack of assembler magic. While
I can test this with git master, I eventually still need a version that
is backported to 3.14. Any chance you could provide that, too?



--Q7Fx1L7nOIIBCfImiBpuB29d1qFQ95SAp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTREaCAAoJEChPw0yOSxol4AoQAJhnLsFmsYBS7GhXWDdT19GN
17fqK2Fcwfuj4CWUuBXjkkap/6uBvxDGoiOX9B6r/Yq5FDSa5laXTYQBP95znSTK
4wKwX1lZrFg7DVjkG2VAMCo9Aekk5+1TNmMVybA9Rt4UiiVfpg2crh4Dvbqhlc1f
6LtK0mqQsVLtkih/3VSv7Fp6EHc3tO9xlzpfNhkTYrCdfGBArQAesn0qhbNgIcwA
98DPBEZTcdbjhc30OxBaQRGOvikQKQh+me30dmujR7AxPGChslnNucKUAUr0Lquc
Xuayy3NVNjG8NlGAl1hvo0+qTb8QSiozExnmXSqskVMSSwFvxFiE4bJt/NrVSHEH
D2fXmP0rgHqXJydl7RjJtRtiH6YQf3SPjOik5phrmZsSQOiqzuBehNEyuDr/b7O9
cKpJW1rh7H2JbBfdafvkmasmpmCIKHq1RKoR+0hfL7UJD+s/zHzUBXfuwO9xQb6Y
uj/rBHXrseHMcLSv+QSAbhWBVaT+Z4JIpcDagD2W5JOaK138KXkMMU/npA3LCUCa
d1VFSrebnchxapZ84klSahf35i0ArErufsrsSS90ukyYTHKPeaP0nk6k7qTv14qr
ofUxBnW5YhzVnryTs+eZ/alFwEjNP19jod3yLNt4onLfw7OpgjEr4aqIvPMG//lj
SL5UMt2TseT0ltpfH9j5
=ldhr
-----END PGP SIGNATURE-----

--Q7Fx1L7nOIIBCfImiBpuB29d1qFQ95SAp--
