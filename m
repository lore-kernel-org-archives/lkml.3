Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaGJJb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:31:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:56100 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaGJJb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:31:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,636,1400050800"; 
   d="asc'?scan'208";a="541341827"
Date: Thu, 10 Jul 2014 05:01:51 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140710090150.GB10182@gchen.bj.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-2-git-send-email-hskinnemoen@google.com>
 <20140709191747.GB5249@pd.tnic>
 <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 02:24:31PM -0700, Havard Skinnemoen wrote:
> Date:	Wed, 9 Jul 2014 14:24:31 -0700
> From: Havard Skinnemoen <hskinnemoen@google.com>
> To: Borislav Petkov <bp@alien8.de>
> Cc: Tony Luck <tony.luck@intel.com>, Linux Kernel
>  <linux-kernel@vger.kernel.org>, Ewout van Bekkum <ewout@google.com>
> Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
>  small check_interval values.
>=20
> On Wed, Jul 9, 2014 at 12:17 PM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > On Wed, Jul 09, 2014 at 10:09:21AM -0700, Havard Skinnemoen wrote:
> > > From: Ewout van Bekkum <ewout@google.com>
> > >
> > > The CMCI poll interval was updated to pick the minimum interval betwe=
en
> > > the original 30 seconds and the check_interval divided by 8 (minimum =
of
> > > 3 polls).
> >
> > Why min 3 polls? How do you come up with exactly that frequency?
>=20
> The idea is that if we make it equal to check_interval, it might
> bounce back and forth a lot. So we need to divide by something, and 8
> seems like a nice, safe value, and it seems to work well. We're not
> opposed to considering other values, of course (e.g. 2 and 4 might
> work well too, but with somewhat higher risk of ping-ponging).
That value looks chosen a little bit at will. How about updating
CMCI_POLL_INTERVAL when check_interval is changed to ensure
CMCI_POLL_INTERVAL <=3D check_interval always.

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvlZ+AAoJEI01n1+kOSLHnZ0QAJ1wOsCSjsfbcynQSG+r8Nbw
51VUhupIZWSrFSPEuz9uTop7crxS+wUgCPPyrfZ17sjeGBMopRJPce7NLeK2oeux
QYaiNCeFHq+W+GY1xBgLoXbOnV+0GOmZFJ9V7znm4QXmzIEhls/Oz1z+8aUYoQlI
ijIeR3e2m2WCzK4GPqRKMMoUFYyXXPo5PLGrp4Pv/XBoEI20QEe3+bkKsLFOqN13
62m/RElJkFUdpRAyshYQQguj39YieOo8fHosqrpBVUumGoKkEDoQ1qUNbssw2qcD
IFw4T0QGv1Pz4OsBG/qBijRp7QHduhUGBXRRD3to3YyOHm0RmOlzJ2dWRJ9O9f+s
u7f/4yLAlYVbJqQIv20wQgUytJfgHKc2gyEW1M9Nd/ciAy/LR7DFOVKHT5SQ03MI
6IUqXEWLpxR8Pg12tvdPFUIsbS+IXtruNB0B1CsNJvsGW9GyMBYPx9xgfJx4UdRx
Se8kdhFOCoapTT4igTx6VZs7jNRPFDZL17uIqLZ3tFer4k2RFG1TOfRORMBwD0md
zsG6vGpdvcXEnD7zGSA9S6gHbD4eVwu1A4r23649JNx0Uhm3UOLd9CYm9NreFlZl
NaXOAcpB+S9DVoBZf6xv891kkSlYFeSB74qYUXlQtIBLZ6uWq/pCgCDhjYRqM4VD
epAYR2dTrrUF9z9qhPEm
=RzCx
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
