Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaGKCmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:42:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:36878 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaGKCmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:42:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="360954345"
Date: Thu, 10 Jul 2014 22:12:22 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140711021222.GA557@gchen.bj.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-2-git-send-email-hskinnemoen@google.com>
 <20140709191747.GB5249@pd.tnic>
 <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
 <20140710090150.GB10182@gchen.bj.intel.com>
 <CAFQmdRbmBDQiYxwdhLyo0kg3tZ=9X8t6+Dgabs7ZO1ZvDvekiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <CAFQmdRbmBDQiYxwdhLyo0kg3tZ=9X8t6+Dgabs7ZO1ZvDvekiA@mail.gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 10:16:56AM -0700, Havard Skinnemoen wrote:
> Date: Thu, 10 Jul 2014 10:16:56 -0700
> From: Havard Skinnemoen <hskinnemoen@google.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Linux
>  Kernel <linux-kernel@vger.kernel.org>, Ewout van Bekkum <ewout@google.co=
m>
> Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
>  small check_interval values.
>=20
> On Thu, Jul 10, 2014 at 2:01 AM, Chen, Gong <gong.chen@linux.intel.com> w=
rote:
> > On Wed, Jul 09, 2014 at 02:24:31PM -0700, Havard Skinnemoen wrote:
> >> On Wed, Jul 9, 2014 at 12:17 PM, Borislav Petkov <bp@alien8.de> wrote:
> >> > Why min 3 polls? How do you come up with exactly that frequency?
> >>
> >> The idea is that if we make it equal to check_interval, it might
> >> bounce back and forth a lot. So we need to divide by something, and 8
> >> seems like a nice, safe value, and it seems to work well. We're not
> >> opposed to considering other values, of course (e.g. 2 and 4 might
> >> work well too, but with somewhat higher risk of ping-ponging).
> > That value looks chosen a little bit at will. How about updating
> > CMCI_POLL_INTERVAL when check_interval is changed to ensure
> > CMCI_POLL_INTERVAL <=3D check_interval always.
>=20
> I guess that would work equally well, but we still need to determine
> the magic number of how much less we want CMCI_POLL_INTERVAL to be.
>=20
> Havard
I mean you can change CMCI_POLL_INTERVAL from a macro to a variable and
then do prove check.

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTv0gGAAoJEI01n1+kOSLHG3oP/2OfBkmAnq5UxFnigaOZnLpH
j7Knz8xxLOlQnUSRQmv1Ss5WZIxrNjQG6eSfUwvDkebVT89Iin7JIzeonavaC+fn
CAYHIISSjEk+ViNayEtjnfcSW4scfM4Qt2jpeSQsvfZCBJsMwjZCjTM9HkyG1pJo
Wahnb+eY3bUrQkcgdi2VIDLKn6/1Dm0L1Z2YMYb7hq/PYHPTqbushhRHToyHrZSh
MFeCSwYYd0sYiHLM8hBnNo88koJ9kabOGCNAG/4t56NwYR4GjaQxo0Rx8Z4API+x
+oldJKW6tjhavINs3pa/LPR5ude12Mk52koHIPrVzwa2oh+DuMW3j+Ky4FBRXfFB
DRgdwYWW7cYIDdt9xKUhjG7Rb1hofzA9IZJXKoN3xyEDdYfqVALbWiYh4Ab/ATmd
BIY5X72m5CgEwDUke8AvR1tTwexSUliJEkdjSYV9ZXMUXwRf1WSgSIg9zNYPLquY
MeZhuudG3SNQmjwKr0Tbht0ZVnmPOz40zI3xfhteAODW5YB58spriUwKkSdNuosV
tamlm3EuNVC1ks+O2uBOFQ+SG2NwhBvP93TTfcgXPjOYxRGPkre/OdT0TUjZM86Q
1rp3YEtJcvJh6xL13idd/tZcsMRzjeF3QGuLxiLhg6T9LIduTYNEO6P+fOmKzRXC
RuPipjtI0YwTIeTHyEm0
=dEBe
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
