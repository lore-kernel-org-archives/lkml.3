Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab3BYOLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:11:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44120 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3BYOLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:11:39 -0500
Date: Tue, 26 Feb 2013 01:11:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.grzeschik@pengutronix.de
Subject: Re: [PATCH] kbuild: Fix reading of .config in link-vmlinux.sh
Message-Id: <20130226011128.192ed5a7d145dd2703b395f6@canb.auug.org.au>
In-Reply-To: <512B5F8A.1060705@suse.cz>
References: <20130225215845.c0ec14a467aa6fe8e788e80e@canb.auug.org.au>
	<1361796898-19642-1-git-send-email-mmarek@suse.cz>
	<512B5F8A.1060705@suse.cz>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Feb_2013_01_11_28_+1100_VupF40=G/.YzpNk3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Feb_2013_01_11_28_+1100_VupF40=G/.YzpNk3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Mon, 25 Feb 2013 13:56:42 +0100 Michal Marek <mmarek@suse.cz> wrote:
>
> On 25.2.2013 13:54, Michal Marek wrote:
> > The shell '.' command is not required to search the current directory as
> > a fallback and in fact newer versions of bash in sh-mode do not do this.
> > Force reading the file from the current directory if $KCONFIG_CONFIG
> > contains no '/'.
> >=20
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > ---
> >  scripts/link-vmlinux.sh |    9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> I was able to reproduce the failure and this patch fixed it. So I am
> going to push this in a couple of hours, so that tomorrow's linux-next
> can include the latest kbuild changes.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Feb_2013_01_11_28_+1100_VupF40=G/.YzpNk3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRK3EQAAoJEECxmPOUX5FEOHMQAKXDK8Qa4Rrg2ZFzOL/VraR2
dbcW58hN7U4aQw84uj6mMtl08h0SYINFzKJutWMwSLcCzze0yXDC5nfcGpHM5KkN
H2eUYbg0RWW+IxeD0oCMo4+s9K2hPwXKg3nSDRP5Slfnpd3R8vSiVocTYgCSD3mX
/523aJq93uUcJGjCGqQz4EUHks+eRK1kfLSqSh1nRhvh3nRE+idimARHRt1HbE3t
Phn2U8/KrBZe8fTwCBg1BWYpdCFIulRZ7aRKECEpyU5hgnw5N/MgF2w4np02HwRs
rkktIsUGqUfYj3ooHRwBPVF7lQTH0RzDX333/weIhIK1mgsMHs1f/pfgw8VfPATk
TBiVbx2JLSTR+Jkm+2MQA+jOedZe7V81EsVsq8RIgmeWAWSf+Cy9J0ay0zMRM2z9
znAKc5TFoZjxAVA5pTvmz3lMFEVKJjRPj36dAektHs1ef9fUYpoxKRuuTfKxN7FU
NCdmmt9/TDvCwjlNgPvs6dREpTode5tH3M3i7qiKxG1p18VtG9B1jvid2P2KxYAT
JneFMzeoH5Vf/VWkuyfzCmUhVVuHyCM+y7OhAhoFAJAjS9COy1hIAbhRcZKnNFA6
SfMRHMCxqHW7mK63C8kG0MrGHr3cBJzmaciZ6izSijfdNer54tjM0dfC1NHj8VZd
TQuEEHAc0Xk/Cz9Prsw0
=PMhj
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Feb_2013_01_11_28_+1100_VupF40=G/.YzpNk3--
