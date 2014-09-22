Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaIVTAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:00:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:56085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbaIVTAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:00:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,573,1406617200"; 
   d="asc'?scan'208";a="595140960"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8A
Date: Mon, 22 Sep 2014 18:59:23 +0000
Message-ID: <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
In-Reply-To: <20140922184049.GB4709@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.145]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_EC97A2A1-4862-4B55-887E-4553185B9FD3";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_EC97A2A1-4862-4B55-887E-4553185B9FD3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 22, 2014, at 11:40 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Sep 22, 2014 at 05:06:27PM +0000, Rustad, Mark D wrote:
>> Well, the whole series of patches that I made definitely went too far
>> - only the first 5 out of about 30 have been posted, but if we can
>> make some progress on generating fewer warnings out of the include
>> files, I think it would be helpful.
>=20
> Helpful for what? Those are W=3D2 warnings which are disabled in the
> default build.

It is helpful for using the warnings to look for problems or even just =
risks.

>> The macros can serve a useful purpose, but they should not be widely
>> used. When to use them is definitely a judgement call. If the macros
>> are accepted, it may be worth adding a checkpatch.pl warning for
>> adding a DIAG_*IGNORE macro.
>=20
> Right, so add the macros and tell people *not* to use them. That won't
> fly.

Right now the number of warnings generated when using W=3D2 simply tells =
people to never use W=3D2. That severely limits the value of a useful =
tool. A checkpatch warning doesn't mean to never do that, just that it =
needs a critical look and justification. That is certainly true of every =
patch I made that uses those macros.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_EC97A2A1-4862-4B55-887E-4553185B9FD3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUIHGKAAoJEDwO/+eO4+5uQaIP/jK2YZ0dFaFP5FabWOHLwZ7H
/HMvdLh/Hze6meVUJmzYIPaf1aj0fBEevR+xI9zPjCMxpPiq1y23FU6kHB3yK3ZU
dK5sXjPpFKHGqCcb6YWDtaYCfstHAmdWzL8P+bEwRBCqwMqPYVKSzR2UPAspBD2h
4gUq2lGTnyT+8qYNFbGKO6ppb+tTZvHs+IaX5Hdzajjh2s1YULT7NBx5jmFscSlg
YHq+xtpMMZPxQW4Io0g8YtagfE8blCpwRs2CqZOICKEILYTbjyUaMDP/ctvmriI4
7V3THtqEZevi0bottb93hpNbRGVO2hnLY1tQ2nTHDv7svP8yxJz2FM5Mz/ubMsGe
jeD2rAy8h0XreiVBW6YvLPzTq9Q/PUhNSPa3LDZ94oeejhVqBACIwKytC/NNtqY1
lg0vzxyyYSXtW5tE/6+g5pDntTK9q1B1/UEclZsBf1CQp/VuwX5nG6d/QrpyuZ7m
HAZaJ7NJayd+N6pb61hHctnSrVXNZk30AQdM86U/OfQ8NujVNh9GecC200jgzlgo
LG7vJf4QfSek+Gsbc4hDUIUOexPtkpfg/y2SEmhP4RkqDCsJE2hdhnIzhkTd+eAi
/O15gY9EWkBNa2Nf3BZQkjWQb6nYCJ8oQQtiptQ2lk97SvssfldMuNpu7sElvV/D
MwE+qZNuXfkH7tblbXGS
=frbS
-----END PGP SIGNATURE-----

--Apple-Mail=_EC97A2A1-4862-4B55-887E-4553185B9FD3--
