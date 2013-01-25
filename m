Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3AYS6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:58:32 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38971 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3AYS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:58:29 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Dominic Hamon <dominic@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        web10g-user@web10g.org
Subject: Re: [Web10g-user] Web10g TCP statistics patch - mainlining into kernel?
In-Reply-To: Your message of "Fri, 25 Jan 2013 10:38:59 -0800."
             <CAO1dsSdQJDKZ+zzCaLgge9wqiNaJFzPWWBLjRkMEswLVOOd0qA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <18855.1359138716@turing-police.cc.vt.edu>
            <CAO1dsSdQJDKZ+zzCaLgge9wqiNaJFzPWWBLjRkMEswLVOOd0qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1359140277_1992P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2013 13:57:57 -0500
Message-ID: <20357.1359140277@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.5102D5B6.0011,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1359140277_1992P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2013 10:38:59 -0800, Dominic Hamon said:
> Hello Valdis
>
> I actually just finished patching a fork from the kernel github repo here:
> https://github.com/dominic-mlab/linux with a view to pushing it up. I
> haven't pushed a patch upstream before, so any guidance is welcome.

A quick browse over that git repo looks like it's unfortunately a tad
busticated - you've apparently got development on the 'master' branch, instead
of starting a separate branch.  This effectively means that it can't be easily
pulled upstream.  Fortunately, you only have one commit against it so
far, so you can probably recover by rejecting that commit so you're back
to a Linus tree, and then create a branch and do subsequent development there.

Question for the netdev people - you prefer pull requests based off
a Linus tree, or linux-next, davem/(net,net-next), or some other tree?


--==_Exmh_1359140277_1992P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUQLVtAdmEQWDXROgAQLKeBAAjqyb56sG//vtJCN2U7Zyw0IFyrlS28zY
gjAEwkPKWKWEf/Y2Iy6/E0Z1QPTvVDRGsI8/r3lmgMmGFcsiOCo5ZNEyu8vJNkD/
c37lrE1rJF1vNLbWiz+/lPRY3VZnvszqokwNW/YFvipb5VorHvY+69vDn2pmR5z8
zxeALrIc2GIWfB0H+K8WP3OXTWw6Z37P1dQp/oWYEMVODMGf4dYfdQGIvpoPc/w6
6zXkMx2FRX35aF2xdbRfSj7pfwM297wlsLwBuitqlukBthsWab9zxLCNNU4AmdWw
MVk/OeW/jl0aUS409CvNHoa/aePAbTpuAKIAq5jnzR7ybwDEGraCyxm52jKLgZTO
tiHwngIfUvSaVpEsrihYRZmRk4Eln993LXGM9dGoZPk091ronbSJ6SMhxxN1T0qg
luZMDXp+cFRGetkBIatz9OGS1gpcYPbG+yZDuGOL2b/tIC2Xqy0zASBpIWurB43F
AAJM9HwdEi3dmCizJDlHrnoUIbNMtMRJ4Fcg4gRaES7fZn1QvMrNvIlJvfO60wH/
gJOKmhJam2avijEkaJH0EAwXZt54hu0vZ0WQg3bxwKc6JIltHUSToQZjZOVmN3Nc
ogZjcZe6uUA951S1y8zSoGFi0fqppG+35xsLwC9x8Tk+fT9yiOpTIzs8j1rMmutV
flKfgXIGc4M=
=kz1o
-----END PGP SIGNATURE-----

--==_Exmh_1359140277_1992P--

