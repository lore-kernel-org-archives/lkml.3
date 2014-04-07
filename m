Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaDGRqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:46:37 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:36518 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaDGRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:46:35 -0400
Message-ID: <5342E46B.4080603@archlinux.org>
Date: Mon, 07 Apr 2014 19:46:19 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org,
        =?ISO-8859-15?Q?Thoma?= =?ISO-8859-15?Q?s_B=E4chler?= 
	<thomas@archlinux.org>
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <52E4CF03.8030208@archlinux.org> <5339F739.2060207@archlinux.org> <20140331233450.GI32556@tassilo.jf.intel.com> <5339FC62.8060207@archlinux.org> <20140405011332.GR32556@tassilo.jf.intel.com> <5340134B.4010705@archlinux.org> <20140407173016.GU32556@tassilo.jf.intel.com>
In-Reply-To: <20140407173016.GU32556@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cA8DqNvs4JDHHSGJliuUBVBfhLoRaEtNc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cA8DqNvs4JDHHSGJliuUBVBfhLoRaEtNc
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 07.04.2014 19:30, schrieb Andi Kleen:
>>> Do you have a specific config?
>>> Specific compiler version?
>>
>> Using gcc 4.8 from Arch Linux with the configuration at [1] and Linux =
3.14.
>=20
> I tested this configuration (with gcc 4.8 on FC20/19) and it loads
> ext4 and all the other modules without any problems.
>=20
> Base tree:=20
>=20
> commit e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0
> Merge: c0fc3cb 9dd721c
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Mar 31 12:34:49 2014 -0700
>=20
> Must be something really archlinux specific. Please do some debugging.
> Also please double check that all your test procedures are correct.

Tetsuo was so kind to install Arch Linux and reproduce the exact
procedure I use to create the kernel (which includes the automated
creation of a pristine build environment) - his kernel booted just fine.
I will do more tests today on two of my own computers to narrow this down=
=2E



--cA8DqNvs4JDHHSGJliuUBVBfhLoRaEtNc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTQuRuAAoJEChPw0yOSxol0oEP/08oFDCmqdfAwytlaCPClCqi
gBmr5zaCUp/FkQ5AfkcP/+NmLyaJQNFyHsz4QxvU080zwgaaOezbz8tuaZskWQkz
d2D6PjL79HmzwlNIiVnCzn28pMYIaN9CCD9L7jx0D2wivorz5U6PbEWwO0A+WO9s
yk8Z4B8D3ykHIEDFokWnlml6/zr7Y1acspIc25qsmFgQnLKIHHNgEqdNvJ9un9KA
YZ3cbuqxPaGpdvhsG/13+Mn9TGEIfd/w6ni8IxOvh+a45oVbYmoj26wLENUqEV6C
WxGwtMPF+tUO0HXIovorEdMMJ92fokTonq76vMMPbmldQgOA3b3L5Qlu1D+lwVX/
C7+wlijMC+k58QoFgVAUgoZeO9OycMxDrcdtomCCktKQ2fQa223jyQnnpxhKj/SG
n5+Ha9tUKO9jrKa4BW9yKiGgrY7NjOKKSmcdHwKe1fiAv+z/jwKmsX4k4DGmfmxn
6TiMOLUSQ4ir/TjZzfQUTWLt8PHqwPqxQW9uPIiywXPI9fFVs52tez4ZWHc5Dmni
N2qD28V92m7npPy2EFJnLuS5bKxkBk9RZvBxOHy44QcY/tygkGeKsUn7pK9gusQr
eG58QLKJX7bIe7+lXJBlZBjsm9FZhK0/cV6UtjTZz1KaQvVlPIYAIdmxlIgoTCAv
Y5ylbWq8suYSCTer/rWG
=tuhq
-----END PGP SIGNATURE-----

--cA8DqNvs4JDHHSGJliuUBVBfhLoRaEtNc--
