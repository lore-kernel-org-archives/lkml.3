Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990Ab3JPUbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:31:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab3JPUbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:31:15 -0400
Date: Thu, 17 Oct 2013 07:31:00 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131017073100.2cab1ffa@notabene.brown>
In-Reply-To: <20131016201410.GA26785@twins.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
	<1381949500-501-2-git-send-email-treding@nvidia.com>
	<20131016200645.GD10651@twins.programming.kicks-ass.net>
	<20131016201410.GA26785@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//1dYiNymH3hnBzyIEuF_a6b"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//1dYiNymH3hnBzyIEuF_a6b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Oct 2013 22:14:10 +0200 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Wed, Oct 16, 2013 at 10:06:45PM +0200, Peter Zijlstra wrote:
> > On Wed, Oct 16, 2013 at 08:51:39PM +0200, Thierry Reding wrote:
> > > Today's linux-next merge of the tip tree got a conflict in
> > >=20
> > > 	include/linux/wait.h
> > >=20
> > > caused by commits 1ab2460 (wait: add wait_event_cmd()) and fb869b6
> > > (sched/wait: Clean up wait.h details a bit).
> >=20
> > Gargh, where did that come from?!
>=20
> Also, wth does that live?
>=20
>=20
> # git show 1ab2460
> fatal: ambiguous argument '1ab2460': unknown revision or path not in the =
working tree.
> Use '--' to separate paths from revisions, like this:
> 'git <command> [<revision>...] -- [<file>...]'
> # git remote show next
> * remote next
>   Fetch URL: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-nex=
t.git
>=20
> And I made sure to update the remote.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

It seems to have moved to=20
  git://gitorious.org/thierryreding/linux-next.git

NeilBrown

--Sig_//1dYiNymH3hnBzyIEuF_a6b
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl73hDnsnt1WYoG5AQK0MQ/+PRAYOK3MM+O4onDuXUtZz7x3//n+c0Bp
Ck7NVqmw21DfzQOeu2UDVIRV5/wB8ua11oaG+9tBkHTjQe+3uQOF729u5KW46eRd
Tq0YbXPpSDj83KVxRTqA/Gj17pHD9mPcmgq4mg5NIkYFd4WkI5UNzW3/afxVCj3m
Th5Oy1rWvJVbuAU0JoIZ2ECcw04vcyZoXBgo0VkBVshqcV1utjl8YHLRow1N5Vvb
LbA9ms4GJ33HInu3r/56YPXY7sidiwky2fmmKnnIZpQ6LGy9aEBWA8pgQD0Mpz9/
Rc055MROykG8jsyyy9g2DWV4Db+pTcXYi6v0zk+ILLUaYH4IUStdUAdvD/nG+xYc
FJeE567FAaocFfn4Eq9APTGKGosbLlkaHVzIhn5f0j7nJFjpXe79rMyiqnCauR81
m0rZ4ULQNANQVpnlLD+AukFVzudtX9Fv+rDE9ShSr2YYIFa5pRUNdkb1TmeEueEc
ZopXXhNlkYXoe/3S2f60DgFT88OPhuhLah9Bj52ndnBmpZkwxx13R1LNOyFuXsXv
/xeJiC4bN2LBjd2jIJ0CfMgP0geWjX/IPP7GCbfP1IKnviJDrGvab5hbkYEYslfh
CXRIP1us6ouPnAg6Vl+CPTQIS8ZIOt1hMD4A8UUeZjvQlIDpeEu31HRtnGm7IVWa
j+toYMRy12w=
=/G5W
-----END PGP SIGNATURE-----

--Sig_//1dYiNymH3hnBzyIEuF_a6b--
