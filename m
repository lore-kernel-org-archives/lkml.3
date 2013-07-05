Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab3GEAEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:04:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53642 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650Ab3GEAEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:04:47 -0400
Date: Fri, 5 Jul 2013 10:04:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Rebased for_next branch in my linux-fs git tree
Message-Id: <20130705100437.48810eeeda014ab0fcd87b84@canb.auug.org.au>
In-Reply-To: <20130704174304.GA30265@quack.suse.cz>
References: <20130704174304.GA30265@quack.suse.cz>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Jul_2013_10_04_37_+1000_7YF.D5Ik7IaS/49v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Jul_2013_10_04_37_+1000_7YF.D5Ik7IaS/49v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Thu, 4 Jul 2013 19:43:04 +0200 Jan Kara <jack@suse.cz> wrote:
>
>   I'm just writing this to let you know that I had to rebase for_next
                                                 ^^^
wrong choice of work, you "chose" to rebase.  :-)

> branch in my linux-fs git tree because I've messed up my tree and for_lin=
us
> & for_next branches contained the same patches but with different commit
> IDs (fast track fixes). When I pulled for_next into for_linus branch,
> the changelog had commit logs for those patches twice which was rather
> confusing. The only solution I found was to rebase for_next on top of
> for_linus to get rid of the duplicate patches. If there's a cleaner
> solution of the situation, I'm happy to learn it for future...

Just leave it.  Linus and I know how to cope with those (maybe explain to
Linus what happened).  In the future, if you put fixes in your for_linus
branch and *need* those fixes in your for_next branch, then merge your
for_linus branch into your for_next branch instead of cherry-picking the
patches.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Jul_2013_10_04_37_+1000_7YF.D5Ik7IaS/49v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR1g2aAAoJEECxmPOUX5FE8gYP/0dhb/VVVPJGb7dtON55Cpit
pfgr2onmx7bQdnbIvQDGBZnTzAjc/w5Yay32hJfmOnDuSQcu3NQeDd3pvyNIbLBo
xibX8HDfVFDHYSc8bMojAAfnE8sMAzRhY5TECkwoqJKdcGzicnBWLTXwTLYdF3iI
67K8vSDSpMdaPe9ukC0biLU9KP4jCcrD1PCmYAvz85T1n8BnQL4jwTTy/DxYr0PZ
osC5jgIQdVSkD7078oHUTIvpEHnkt/K7jiXwsD1AQe7qbTfvZ/PueS9zJ/Jd54K8
3aIiWZn7Qg+zfWJASrbPzZoNt6b59Kbw6LZ3dG0uvTnj2LZpAEVFaBEHVdcbawnw
sWDNac7LYgSkzoPB69v/M3FALKZzGtgqU4G1ixUfR7wHz3fGkXIPYuBoudBGkz5L
75akEu2t3SqxTZNxYHIiYA174l0GCLbs9KqXQ2rFZeu0ae8URiTaYuwrm2IXbq9m
JVVauS+Tvj3X8yj1SMFVIc1OptGfPLPe0CkJ71wL8TnDHidbcfeWUeUOzUI0hDY6
JI3DsMfQDCBy6b41kAMQHim4EL2QKdnyAXGY/mfepY2MbKelcXkocT03Bi2mPf1/
TatSNEv+LcufTefCE4+62Zaa8ENBDP2lV48f/ykvFOfHsquZAC+8PFDHY77F7KQ4
aupiKoHPamdTTuAbYQNf
=Gh47
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Jul_2013_10_04_37_+1000_7YF.D5Ik7IaS/49v--
