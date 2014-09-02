Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaIBCFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 22:05:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:16454 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaIBCFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 22:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,446,1406617200"; 
   d="asc'?scan'208";a="566858518"
Date: Mon, 1 Sep 2014 21:31:59 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 0/5] PCIe, AER: Misc cleanup
Message-ID: <20140902013159.GA14916@gchen.bj.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
 <CAErSpo4DZboL75xa1Ahxr9aoDg_wyad1gZpXeAAiqcmx=8N8sg@mail.gmail.com>
 <20140814015236.GB28066@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20140814015236.GB28066@gchen.bj.intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 09:52:36PM -0400, Chen, Gong wrote:
> Date:	Wed, 13 Aug 2014 21:52:36 -0400
> From: "Chen, Gong" <gong.chen@linux.intel.com>
> To: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>, Borislav Petkov <bp@alien8.de>,
>  Tony Luck <tony.luck@intel.com>, "linux-pci@vger.kernel.org"
>  <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org"
>  <linux-kernel@vger.kernel.org>
> Subject: Re: [RESEND 0/5] PCIe, AER: Misc cleanup
> User-Agent: Mutt/1.5.23 (2014-03-12)
>=20
> On Wed, Aug 13, 2014 at 07:52:45AM -0600, Bjorn Helgaas wrote:
> > I haven't responded because I've been on vacation for the past three
> > weeks.  If there's no change in the patches themselves, and if they
> > are still in http://patchwork.ozlabs.org/project/linux-pci/list, the
> > only thing reposting them does is make more work for me.
> >=20
> There is one difference existed in Patch 1. I add more explanation in
> the comments as Boris suggested.

Hi, Bjorn

Any comments?

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBR4PAAoJEI01n1+kOSLHG8wP/3c5jeGxOLELLqUsLXVN1S5R
N6EUZ0xpgSWGRlJrHD/mnUAiygSJ4G04DKUqTLMNET9Abfalsr1lMmI+Q762QYY1
OsayTtuwwaaeJtfk1p0pFlMmjXDNhhIuv8scfq9AV2vm9WqxxEd9rpcLUIcLsp2z
AcutviE66XR5G3nB3zxY9ASIVJDJ7A8So7EgF9ajGlHYpAmp6xbW2qzry1gDoeZJ
QDXcEFp9MbUUfewdGuvYq+epOpfEr2OpwNfSlnAl949cDap/RdvXgdrQs+U1gvM7
cqatmDoB/qWhRs+jfI5zPq1BdACO5njCtxntHDrWaKBGpSA+hm/1xmC/g/5En7Kz
cqQJC+NHM2wkhphmktQVJsmzWMxDLkxUvGpBJ3wJqYQSG/KLFy1fl9SneKTztlGz
4D7I/BpRBMF9QA1LS7LBMh7XJ64tJJOp8+TLRtNuoH0BSVuATPH6pNKrKRx0k3bX
4qm1TU4KzERMjbYTitv33Cu/SHj9SNL5E0IXzCtu12SAIEam6bS3/2szDCUGTd8L
de9UbIMkvUaQlVduxav5K/3SpoDrjKtfsE3wtf2+CqQzxzZvkhGwXeC92GzYiZqt
kLY9ZAzMbRvD8Sbsx7JKEZ5N7U4Ifnrb6B26x4s2Qa0r3gDJqBZR3jOXh3lMTVVh
K08O7/VnKCCAJiHswJFm
=y6e5
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
