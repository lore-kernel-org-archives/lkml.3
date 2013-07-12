Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3GLA2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:28:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51674 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab3GLA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:28:10 -0400
Date: Fri, 12 Jul 2013 10:27:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase of the jdelvare-hwmon quilt series
Message-Id: <20130712102759.7bc9e68271b1b0ad6b0f4fdd@canb.auug.org.au>
In-Reply-To: <CAP=VYLrNH8pZJUPyfZCtLGGQn_ZcBWbNynSHrwYpeKmqqE6Bsg@mail.gmail.com>
References: <20130711102724.51608a4ace419b6d42591257@canb.auug.org.au>
	<20130711075700.21d8482c@endymion.delvare>
	<20130711165343.f921e147403570508939f2df@canb.auug.org.au>
	<20130711093928.24490f06@endymion.delvare>
	<CAP=VYLrNH8pZJUPyfZCtLGGQn_ZcBWbNynSHrwYpeKmqqE6Bsg@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Jul_2013_10_27_59_+1000_Z/k13S7nK./nKfjz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jul_2013_10_27_59_+1000_Z/k13S7nK./nKfjz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Thu, 11 Jul 2013 19:17:52 -0400 Paul Gortmaker <paul.gortmaker@gmail.com=
> wrote:
>
> On Thu, Jul 11, 2013 at 3:39 AM, Jean Delvare <khali@linux-fr.org> wrote:
> >
> > FWIW I would have accepted the patch even if it was not trivial and it
> > would have gone in linux-next just the same. The only difference is
> > whether I consider the patch for this merge window or only for the next.
>=20
> The linux-next tree should not see "new" commits during the two week
> window of the merge window -- only content for the active merge window
> should be in linux-next during the merge window.  Once the rc1 tag has
> been completed, then you can add new content.  This has been something
> that Stephen broadcasts regularly for each merge window start.
>=20
> So there is nothing wrong with accepting the patch, but if it isn't desti=
ned
> for this merge window, then it should not be forwarded to linux-next until
> after rc1 gets tagged.
>=20
> > Is there a policy to not include new patches in linux-next during a
> > merge window if the patch is for the next merge window? If so I wasn't
> > aware of it. I always considered that the earlier a patch gets in
> > linux-next, the better.
>=20
> Yes, see above.

As Paul said, new material should not enter linux-next until after -rc1
is released.  In fact, every time Linus opens a merge window, I send an
email to lkml and the linux-next list saying just that.  I also often add
that message to the top of my daily release announcements (though I
forgot during this merge window).

This restriction is imposed so that maintainers still getting their code
into the current merge window are not distracted by reports of problems
in linux-next to do with code that will not be merged in this merge
window.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Jul_2013_10_27_59_+1000_Z/k13S7nK./nKfjz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR302TAAoJEECxmPOUX5FEXScP/R9QdC2qCk2q8zzljDXBZQio
MpmllDibyWWzG6jpeukCgJIkZv3fThhkI276J6aDYSS3LOl2slLPhMa0LzKDP5AI
/qqvVOBp5IJuj9t35LYfSJc0v/mYxJRrFCUI0DjG7fkjyq59QAwsYGrH7hkgxP8a
MtOh9cqj0/rnl4QIQI9hX27cZ8BvV6xNdx8RVf5PhjXV9YXb/oP/iOHXHBQ605zO
CkOpqbCsgqQNFth9laR7lql+OdHhKym7+nt6Bay97gPygXVPFp3I81pCXNb8Vv0G
9Y/Esn5yeHVnm6Dij19o0RwOG4NMe65RcPwukJrhDfEvhNOkPrwhHFf1LESHQn2U
PNbEQ3X/E9u6ojP8hEUQ1Zjtxfagykwy/yl5h/4WDvNbd20gVW4YGvEu5d17QRFJ
3yHwA/SqkSR59V2cbRC9QpaqRzBcp9sIdiBvLe7w17JrqUe6Ke0Zfrq/+furYsoI
x0avK4POt5m3og76IN4stc4eWoQ5NIFohhkYARZnQAZMSiQxOGC9pv/Pg92CexcR
vY+hPUt+LsVOXkVDZv+L1HucgtMyx22GZHAltzpg7da91UwfSklhhFtdXMBxDwTx
MVNzL/uVJCZ9HAd46OVZWjmatwPO8dtjcmW5PwUPulJ62d3bbql7dg3CLQiEnEFx
jxRKqZc7VxEdSd7e1G5v
=r1V+
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jul_2013_10_27_59_+1000_Z/k13S7nK./nKfjz--
