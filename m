Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3KHBxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:53:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58239 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3KHBxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:53:35 -0500
Date: Fri, 8 Nov 2013 12:53:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-Id: <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
In-Reply-To: <527C2AA9.9040608@oracle.com>
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>
	<5273C473.5070803@kernel.dk>
	<20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au>
	<52740EB1.2070901@kernel.dk>
	<527411DD.7050008@oracle.com>
	<527414DE.9090704@kernel.dk>
	<52756583.2030808@oracle.com>
	<527BE7FA.90904@oracle.com>
	<20131107192545.GA20624@moria.home.lan>
	<527C2AA9.9040608@oracle.com>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_12_53_07_+1100_MAeV.Yun8aTmfuh9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_12_53_07_+1100_MAeV.Yun8aTmfuh9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 07 Nov 2013 18:04:57 -0600 Dave Kleikamp <dave.kleikamp@oracle.com>=
 wrote:
>
> Can you please drop the aio-direct tree for the time being?

OK, I was afraid of this, but, yes, I can drop it.  I am not quite sure
what affect this will have on Andrew's tree, though (hopefully not too
much).

This is a bit disappointing.  Dave's stuff have been sitting in
linux-next for quite some time (probably too long) so it is not as if
Kent and Jens (should) have been unaware of it.

> My stuff is not aligning very well with the immutable biovecs and Kent
> has a different approach in mind. I'll be working with him on a
> replacement that will hopefully be simpler.

Presumably not before v3.14, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_12_53_07_+1100_MAeV.Yun8aTmfuh9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfEQLAAoJEMDTa8Ir7ZwV/BwQAIK1xA9TbqYE0pPtRJ3OpIYf
c2K8ntg8Y7tplVs7jStDx/GkUPWu1x78aaYwphNH1HwVAgzta1UDlJtbtrXRbG5c
j3MswqSXvDpktXT5agQJruBqzGTU8maU3ZPvn9aFaSPhY9o7gJM/JuqdkZ+jh3fb
Dqw9fiDLnW/NQDVC4l8fSz8hX9/1NxcqJknzDh5qAn4DNM0rp1RCWSELdHW7hwKX
PtoBvcfSP+NdJxGPCO6F0J4XF1Q19Hqj2EIYqAhKSDtQHwfKpVZvEfF4PNfm5CFz
SozqXREd9S0IOGyXXtmxr9ttZW44bxN+KEnkKmXELgcXjwQR+LlMFhI6e/Y/mPJN
vIPqMxM44ABPz1oKYOPlvZBQyocs8NReTHzZYJj4+XrGP412lyymgQGAF4JXycdd
aYiCXjcGF+k4aIAIRzDboU4C2VYHvGAhyw0gBZbFlru3fRH6vUv4TSiKbvzFnl1W
rRjpnrgQvCylUwiF6neVISPAbnbpwJVaGN7b8K6GDi4vBurhv2G/GIr+JF4df+l5
4ZSzyjhlAKxHzcjCnR3Y/1IdM4ghOK42m6xmr5pfsTH+at1Lo4k8khV87XPeRTmq
htKT/utGy8MAqzQmekPWVpSJAsHYl1iNT2nEYJUinDNodhIN3w2e63UhWWRB1FcD
aulj9tzjIlBG3+/Ipb1D
=Sv1p
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_12_53_07_+1100_MAeV.Yun8aTmfuh9--
