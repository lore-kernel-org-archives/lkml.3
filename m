Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3HUAOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:14:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40435 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3HUAOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:14:17 -0400
Date: Wed, 21 Aug 2013 10:14:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-Id: <20130821101403.1706678a4bbdebec4756ee54@canb.auug.org.au>
In-Reply-To: <5213BFCB.3010503@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<20130820130056.GA9652@infradead.org>
	<5213BFCB.3010503@oracle.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_10_14_03_+1000_F0EHGU7YJHFB65j6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_10_14_03_+1000_F0EHGU7YJHFB65j6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 20 Aug 2013 14:13:15 -0500 Dave Kleikamp <dave.kleikamp@oracle.com>=
 wrote:
>
> Would you be willing to pick up
> git://github.com/kleikamp/linux-shaggy.git for-next
> into linux-next?

I have added that from today.

> There will be some unclean merges, and I can send you updated patches
> created against your latest tree. I'm not exactly sure of your process
> wrt cleaning up merges, but I guess they would help.

Since I will merge your tree into linux-next, I only need to fix merge
conflicts, so while those patches can be a guide, they are mostly not
needed.

> On 08/20/2013 08:00 AM, Christoph Hellwig wrote:
> > As I've seen very few replies to this:  how do we ensure this gets
> > picked up for the 3.12 merge window?  The series has been a reposted
> > a few times without complaints or major changes, but the ball still
> > doesn't seem to get rolling.
> >=20
> > I'd really like to do some ecryptfs and scsi target work that is going
> > to rely on this soon.

If this happens, then it is important that your (Dave's) tree is not
rebased/rewritten and that any other tree that depend on it merges your
tree.

I will merge your tree relatively early, that way the merge conflicts will
be spread over several other merges and hopefully each be fairly minor.

I gave called your tree "aio-direct", please let me know fi you think
there is a better name.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__21_Aug_2013_10_14_03_+1000_F0EHGU7YJHFB65j6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFAZRAAoJEECxmPOUX5FEDaoQAJ1LBBb3PPzZwqsnBi++NGMx
9nJeVVmixXPdsiqG0y+APLA+xt8hEhdmqsgPrd9/dR0Z1DF0/0pLwEGFidQvVrmF
sxVPPELTiIdFslFU/Pgci3CR6DeBYbcoNIhnx3Bumy+kw/EIEm3JPEecObRz8dfF
MzhoWhFN8B0MSxGKitrE6YSt2aOfH9UpZvVxaUP9atD7TbYRpDJh/4SCrWRsakMF
CfL86Yc9vY84udQMtmm0BhBCU+78pSChDmQA5TZUayjkf7DU21qJN8DGQx68WbGX
YXRbNlqTe5CFqPIEZb+DGFOz0JXgQrI53bRmKUSprhbgOJQIrDKvUKYE5nc4D2V4
yPz2h0HpF81exan7aEAMGTgFymgJ0s2iqEESl5cGHZ6mhOJEKLv89jLOkewcaXca
TiY5uURgp4bVzBxQLck+5MsX26+RkoR4eHPK8HFVb/xO4c4FUbJFCeXK0Jd5Dc1n
/9d/pmFrFfHcIDjHHT9JK2zQfBDQrX+MUKyHpYe4WG/FfqRRQMLqub4rORW39o5K
+Dz/ojOk2W0syXL85jswu9BVbZDyVjMfW9ctKHy8e/qb9/Ov3/rDC3peEOPAdHeE
pQCugjyfTv7bLftLn5CTyhXeojT5ea1MD5H8hoR4mFemA3jKbB4Hm4LMQEhpYBgy
7Vg78QszJdWioOj8GZIe
=IBCy
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_10_14_03_+1000_F0EHGU7YJHFB65j6--
