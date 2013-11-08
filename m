Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab3KHXVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:21:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45650 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109Ab3KHXVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:21:12 -0500
Date: Sat, 9 Nov 2013 10:20:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
Message-Id: <20131109102058.4edc71a4a367d3d6c92844aa@canb.auug.org.au>
In-Reply-To: <20131108185812.GB11311@jtriplet-mobl1>
References: <20131108184805.ec16e3b5cc08834cb5d4f812@canb.auug.org.au>
	<20131108185812.GB11311@jtriplet-mobl1>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__9_Nov_2013_10_20_58_+1100_TY82v=Oi2_KN6HV9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__9_Nov_2013_10_20_58_+1100_TY82v=Oi2_KN6HV9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Fri, 8 Nov 2013 10:58:12 -0800 Josh Triplett <josh@joshtriplett.org> wro=
te:
>
> Won't splitting the Makefile change into a separate commit break
> bisection, in particular if you have the changes adding inlines but you
> also compile in lglock.o?  Shouldn't this be squashed into the merge
> itself, keeping the kernel/Makefile section of my original patch?

Actually it is not a problem because that fix patch was applied to the
merge commit between the part of Andrew's tree that depends only on
Linus' tree and the rest of linux-next.  So each side of the merge is ok
and the merge commit itself fixes up the conflict.

I just split it this way for my work flow purposes.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__9_Nov_2013_10_20_58_+1100_TY82v=Oi2_KN6HV9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfXHgAAoJEMDTa8Ir7ZwVyU0QAJI9CWTgr+1ImfZ67ik2EaXX
9085Ofn8i+1txU4NmXdGfjtJ8gMLyJ5cy0gZm/PSn9WkgsWZ73a+r2VABgH43k1E
8V9cx8S5G105MNTWgklyYwJn2R0c3vaeTWore7G9dcVg8i/4YMrhpSWNJAxfzBm8
BtBFJNH93tqpYfk35vaPlyVG29g5Wo1gXymvVA4hg86vvIb9NkmWUeY6kU+ae8a3
3s9Es1N+51A+tHgVtCUCeq1R6Kb9EDJ+B6nLgG599Gz5PU2SSm2XPMsInGFa2lHF
FgzRY4WQpsOxGO1tEdrmhCSKY1P+eT6ppmqu8f1k1G7GZa/urlmzQZy8SDA5Q2In
h+6XyKjw6LbWV1xZNikMiAnMdz4VDAwUtEhPn117sasT1460wbPKSZbZf0fFFhbs
PAeUmtD0JAxgYp3ymJnEVUNHb6xaiW8o+4N7GTlqSyVVfeyCSRmc4fODMWFJFoq1
+jqfkgJreG4BuJv3rpT8CkxgOeiRRTV3ET1Ea0VrJjEtulCKO54NURF+JR/qEA6q
y/7LAQSW+aZBsgrDKg5HwsU6BFfwrXhvlObXYi5Y1Mo3opMc6BCoJumamRam1fUE
YCzIDUIa59Kjr7TeQQqJipTbPzoH6JjW58QOXIlgB22mPDBxZ5gX9kduAXGP2nYn
MomD4T13x+7g7ImzdCAq
=w9Aq
-----END PGP SIGNATURE-----

--Signature=_Sat__9_Nov_2013_10_20_58_+1100_TY82v=Oi2_KN6HV9--
