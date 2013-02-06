Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab3BFVCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:02:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53739 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab3BFVCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:02:51 -0500
Date: Thu, 7 Feb 2013 08:02:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-Id: <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org>
	<tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
	<alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com>
	<1356564746.7010.56.camel@shinybook.infradead.org>
	<50DB9FA5.6070704@infradead.org>
	<alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
	<20130204184436.GA13256@gmail.com>
	<alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
	<20130204191408.GA32081@kroah.com>
	<20130204191334.GB14837@gmail.com>
	<CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
	<alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_08_02_36_+1100_br/JcIG7Z.exlXt4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_08_02_36_+1100_br/JcIG7Z.exlXt4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 6 Feb 2013 12:12:57 -0800 (PST) David Rientjes <rientjes@google.com=
> wrote:
>
> On Wed, 6 Feb 2013, Pekka Enberg wrote:
>=20
> > > Yeah, that's a good idea - I think Pekka can apply that change
> > > just fine to help anyone doing merges - I don't think kconfig
> > > treats it as a fatal error.
> >=20
> > Applied, thanks guys!
>=20
> Adding Stephen to the cc.
>=20
> What's the endgame for kvmtool/next?  The patch that this fixes has been=
=20
> sitting in linux-next for over 15 months and hasn't been pulled by Linus,=
=20
> yet some find it to be quite useful.
>=20
> Is it a permanent addition to linux-next, is there a route to mainline,=20
> or something else?

Linus has said that he will not take the kvmtool tree in its current
form, but would prefer that it be a separate project, so I should really
drop it from linux-next (and ask the tip guys to remove it from their
auto-latest branch).

I have actually been meaning to get back to this, so, today I will drop
the kvmtool tree and, Ingo, if you could (at your convenience i.e. when
you are next rebasing it) remove it from tip/auto-latest, thanks.

This does not, of course, rule out it being reinstated if Linus can be
convinced.  Nor does it make a judgement on the project itself, it is
just because linux-next is meant to represent what is to be merged into
Linus' tree in the next merge window.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Feb_2013_08_02_36_+1100_br/JcIG7Z.exlXt4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREsTsAAoJEECxmPOUX5FE0P0P/25P8joCeQkKwhIGJgTfkqIY
/BDxSjSVPDXWrSjpWBCSrkWnnO4rLSFDuCj0Go4mypZMYWs86WpWv0g64e+DxWGf
EgAxBghlr+Kb9NQ0zD138n9LZCVmLVqeDqmPsMBHt0Eykp98k4cM4hDMDsPEDOpu
JiAT8CZc2GuiYgJlkd1hg1/wKgZ06yOuySflifKjQY3zmAva5w6JjCyr/X7IA61+
KgSV3vkcnJT/TwkBZ3HHx9JYYvKrb+Vv1U6NvH5iLq9jHbsEMMfp5QGA6hcZnSLE
e5KjMS2VvvWT6q0sq7xmrlUvXakETYyAPlQSVe8tTrefpkBW46VPIh/EMJR7kFHm
cHJWweqzJ//+EYhEwNBksgsL8FJ+f9pQJOAWyy+M/SQ3tCWH36RDZBmJg65UbDrj
TFIPn3tTfjgJuDW9bSBoxpfbjDfwvCyL/YxRqzRIuiF89BMlThdgMD0/ARyGOdKr
yZVLRSW4rgzufDEdkJBP7Nk6IPD9EYKzInTXp2EkRiHjDZK+Oy9BJNZUS1z7pDdR
3qjRi5IfF9mPiFPOytoBLAuI16Fi+wq4pjCxgDqmcIiY/QicoluPhCdgvocuKVbz
tFUXcE2KB/Gczhg3iMoGCpDExlCg/3NUB1d3LOEplpoaCaUgH+G+5FUmUbkg6TGe
ZPICCnLQXmk7JocQUlyC
=uS/k
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_08_02_36_+1100_br/JcIG7Z.exlXt4--
