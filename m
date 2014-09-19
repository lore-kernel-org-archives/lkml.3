Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbaISUup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:50:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:8996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894AbaISUuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:50:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,557,1406617200"; 
   d="asc'?scan'208";a="605578768"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Richard Weinberger <richard@nod.at>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>
Subject: Re: [PATCH 7/7] sched: Silence nested-externs warnings
Thread-Topic: [PATCH 7/7] sched: Silence nested-externs warnings
Thread-Index: AQHP1B6e1FZqApYsAUeDZBBK/84gU5wJTqGAgAAQ1oCAAAHIgIAAAmKA
Date: Fri, 19 Sep 2014 20:49:53 +0000
Message-ID: <09D2323D-79B7-423A-9BA6-504112AFE104@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1411140580-20909-8-git-send-email-jeffrey.t.kirsher@intel.com>
 <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <11081C57-805A-44F8-9768-271DC6B27F76@intel.com> <541C94F1.9020206@nod.at>
In-Reply-To: <541C94F1.9020206@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.66]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_FC277461-5FEE-49C4-BFF3-B55576FF17A4";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_FC277461-5FEE-49C4-BFF3-B55576FF17A4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Sep 19, 2014, at 1:41 PM, Richard Weinberger <richard@nod.at> wrote:

> Am 19.09.2014 22:34, schrieb Rustad, Mark D:
>> Excellent. I'll try adding an include of delayacct.h instead. My =
patch was based on the assumption that the existing code was wanted in =
that form for some reason, so the patch served a purpose in recognizing =
that it isn't. So the macros have served a purpose before even being in =
place. :-)
>=20
> I bet sched.h does not include delayacct.h for a good reason.
> sched.h is included in a lot of files, maybe delayacct.h introduces =
nasty dependency issues.
> You'll find out. ;-)

Right you are, but when I'm done, there will only be one extern =
declaration for that global, which is better than more than one. I'll =
think a little before settling on the best resolution.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_FC277461-5FEE-49C4-BFF3-B55576FF17A4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUHJbyAAoJEDwO/+eO4+5uPxQQAJVRXx4Od4WCkQCggtUxqkJN
EDEnEqCSORD98TWjakQ/DRrdimzlnjZsK1gJLVHIp3kvB9iOs4Zq+Qto43UgtngR
Uh4M4EFQ05OH4xou2s84i8vZ1H6T1m1z8sw8tpjYLpcPx9llQZX4/AdlmORDHyxt
0YPBG4ivSHzywBe3eYA3DnUTfcVc64Akq5Bnau5+iKfaPsibSkNTGHWtbFH+CBRH
GNZgrWWPQnSN5Sr3ApxQ/d1lRHChW6dmE49aRVHPEDkgJoHPD7cQAhkCGqk3y6qa
/gd0heR7z6obzCfbWcz7PjsVoRdS2SdfpE1/Lo9Y/FPCrSXFr6QdB8fPeu8m0HBr
RLVrcqy0+QVA7RUONQXp/hITMoBtrrFy47vD9Iy/A1NL2GY1UsZtizym+KAyKe8j
gBiGUErhAoND9hHuMpwHSrMQ/WguEol16aPWAUTqWwx1oWBoJlQOcHcdyeHkwjer
kub50MXstQO4lVeDo+OlgYmLHVBWbywrf03q7Rlr578y5FVW0d2FCxW0A/90zrX1
T6gOIiZAD1iaNFFdFdrtwdkqTrW4yCHzAD5qUy2eaYfzDyuLjS3u4aNQDb4AI0RQ
S7QA8m2Qatu4B4q8/33oc5HPrmaoLKxNuX4RYNonO9pnMI8hiv5ypKCbjBkixJu+
mPkydO9WnYw4lWH8frnX
=02gi
-----END PGP SIGNATURE-----

--Apple-Mail=_FC277461-5FEE-49C4-BFF3-B55576FF17A4--
