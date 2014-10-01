Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaJAVVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:21:15 -0400
Received: from sauhun.de ([89.238.76.85]:52259 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaJAVVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:21:13 -0400
Date: Wed, 1 Oct 2014 23:21:46 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Guenter Roeck <groeck@juniper.net>
Cc: Danielle Costantino <danielle.costantino@gmail.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Subject: Re: Fwd: [Proposal] PM sleep children of inactive I2C bus segments
 off Masters in multi-master systems
Message-ID: <20141001212142.GB2368@katana>
References: <CAAVjN7eUmBVcAGPbcn3qsJ9M9uu2nkFoKHqGhhKGekZSceGiMw@mail.gmail.com>
 <20141001184304.GA6832@svl-evodev-groeck.juniper.net>
 <CAAVjN7edpkXYMHBm+wLegA_pc0hnm_YZf_z=Ni3h=EbDTmfegQ@mail.gmail.com>
 <20141001194115.GA6948@svl-evodev-groeck.juniper.net>
 <CAAVjN7fGRzyu7gxavJUay+K_Mm-0t1T_0Bysk6-sdaqu5=5k5A@mail.gmail.com>
 <20141001202058.GB6948@svl-evodev-groeck.juniper.net>
 <CAAVjN7e4nO579TfAJ5zMNe__Q9yU_-6naq4-0vm1rimespSrsw@mail.gmail.com>
 <20141001204302.GA7744@svl-evodev-groeck.juniper.net>
 <20141001211046.GA2368@katana>
 <20141001211657.GA7904@svl-evodev-groeck.juniper.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20141001211657.GA7904@svl-evodev-groeck.juniper.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 02:16:57PM -0700, Guenter Roeck wrote:
> On Wed, Oct 01, 2014 at 11:10:47PM +0200, Wolfram Sang wrote:
> >=20
> > > Maybe you can find an error code which with some level of confidence
> > > reflects "lost mastership". Then you can implement whatever makes sen=
se
> > > for your use case in your user space application(s).
> >=20
> > We have a documented fault code for ArbitrationLost and that is -EAGAIN
> > (see Documentation/i2c/fault-codes). If a driver does use something
> > else, patches are very welcome.
> >=20
> > Other than that, I find this thread very confusing. Of course can
> > another master modify the clients, this is what multi-master is all
> > about, no?
> >=20
> That is the point I was trying to make in one of my earlier replies.

Yes, and I wondered why the thread continued after that, so I thought
I'll bring it up again :) No, seriously, I did not understand the reply
to that mail of yours, but I'll try again tomorrow after some sleep.


--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULHBlAAoJEBQN5MwUoCm2K1QP/jN4YVaUcPzQpRwH1pVy/hCN
7k+koSKRHe9IXi5yUPex0mIv54r7wO+hqV5kVKzSWh3CXSaUtqqKgPDfcIv4a1YJ
Fwij5Tz7xuYV47fNyke3507Q5XgAaPDb1YBS6SVfezuzN53SPexT9wC34Kh0niMw
kHhNFJmb4DLa61QIFMxvWU7kQylnLBwwnpnbFxry6NhWzNsAHGykIps77aiofeML
Az8VQ39/6FiY3xzVY5S2ROvvKgaGbgneJk3/9qq/4u5S4v3m5BxLrXTFNWS1IJFG
aqu3No9mhVGoWPdY7lOjqKB5mOBTRpcJVjJT4+Jpq0R9x5gCfH09r1EV/XsC+QPt
LWPE5OYEQNev7OQU1kdDLhwuOz2xNgFmeob/MCrG+WYxbcDZnPzB/6S1RtHziYC1
5+n1MvfXhQ1MXh8/M/6x+9B6H5SEEssRQkN09tBfDepbVVjAhvsLe8KO2u1Hzebt
BuK6MQhd02pRMx4bn3Rn4vIaYs/YM6esPWnknrDee59Wrb3lhxb3NkWC+rYe7qrV
wO0w7HNX6gv0k9E1LC15+BBg8W8Hj96okayOoK1WSnNIaI3p9VS2IEy0ulOdaIT/
E6Esb3GvVatjZikfzVYwqa22x7061t+WOR0Msi4XqVHM2VrDwR4QQHwjBvPVrTPz
YCPaC+53bil6WZrmRDy/
=nxSz
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
