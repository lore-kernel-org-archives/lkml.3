Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaIVVvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:51:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:42904 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaIVVu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:50:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,574,1406617200"; 
   d="asc'?scan'208";a="479276857"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8AgAAGSQCAAAZEgIAAA7mAgAADVoCAAAa4AIAAFZkA
Date: Mon, 22 Sep 2014 21:50:54 +0000
Message-ID: <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
In-Reply-To: <20140922203336.GF4709@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.145]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_3071C6DD-CA50-46FD-B042-6C67EFE39B26";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_3071C6DD-CA50-46FD-B042-6C67EFE39B26
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 22, 2014, at 1:33 PM, Borislav Petkov <bp@alien8.de> wrote:

> Btw, out of curiosity, what is your use case for staring at those W=3D2
> warnings?

I know no one cares about out-of-tree drivers, but I have a hack that
allows building out-of-tree drivers without getting warnings from the
kernel includes. We do an automated compile of every patch with W=3D12
and expect clean compiles.

It would be nice to compile drivers in-tree and have a similar =
expectation.
I guess a similar hack could be developed, but since we are contributing
upstream, I would rather uncover any potential issues that may exist, =
even
if they aren't in the driver. The hack would tend to cover up such =
issues.
This is definitely NOT about covering up things that could be problems!

> In thinking about it, what we could also do is simply move the =
noisiest
> ones to W=3D3 or so, or even add another W=3D level. It'll be =
interesting to
> hear your use case though. AFAICT, this is the first time I hear of a
> more, let's say, serious use case of W=3D since we added the W=3D =
things a
> couple of years ago. :-)

Well, I have W=3D1 in my environment, so I don't even have to ask for =
it, I
just get it. W=3D12 is just insane, or I would use that all the time. I =
think
it would be nice for new code, or at least new drivers, to compile clean =
with
W=3D12, but that isn't possible when the kernel includes throw so many =
warnings.

Nested-externs, for example, can catch people gratuitously providing a
function prototype that could become a hazard, but some use of that may
be justified. The macros provide a way to specifically allow certain
instances while generally discouraging it. Of course if you never use
W=3D2 you may never catch those gratuitous declarations.

> Thanks.

Hopefully the discussion is somewhat useful.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_3071C6DD-CA50-46FD-B042-6C67EFE39B26
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUIJm+AAoJEDwO/+eO4+5um+YP+wYhTlHLtY/NXi0uCam2Ch1Q
n47HupsSsbFQRRWMUFhzEWTrn8rcDTfro6CoH+HRE3Ht6aHkTt4bRk2mtZEGNiKG
ZWd2wizys5FzwJy2mGC4uyZczeToyOfUXjVdYmH/f4ySPIWmzJ4Fu5ueOf8S0Szo
pqeKmcspku3+fcgo/ECxad2WRL29FRgdes8k0XracyqG2Bn7Wep5M1wCoGeUZdF4
r6JIlrxPMX3VDzPUZ6ISB02AJ3u56eoOWIh3y6Taq+cIl2uNdXzek5JCp7DRJJhY
Zpr7+Z+w6DPBS50Qm0TTOwRQh7AkpzEk1Wp4Gq16k4hBmu2HCrG7saTjbTAwDS9n
0/gDUwAAT2fEyfvU6bHOYaC9raPDWYriPCYGYQ9YZxhqIDb15BfmUqHVuCrEqc1C
2oqzOyLoJkwqlRgZlq4f9AVRokcIMwUZzkK2LZeJstdVabm9cPYegWku3qzLTNdT
XRyEoiwWNiDzUlU8lxvQGpkQ/EYS95Jwo7LchSoDxx0/yvx+7RPsDvjRQcCs8ou7
SewicFui8sEF/lzDv3MabPsfyGC46j5/R+ivPFyXelv/jxRvDmDQS/ag+YPEiYOG
b1vn4VVGI8hw+TGPIqjW/QsacjjMGCbxOD+fKXkDnfvkevVOy3bCfmtjlIUcdyM6
AgS8nZ2nxpyebV+/DDe+
=YA4e
-----END PGP SIGNATURE-----

--Apple-Mail=_3071C6DD-CA50-46FD-B042-6C67EFE39B26--
