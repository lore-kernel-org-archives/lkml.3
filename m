Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab3E2ASe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:18:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39863 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3E2ASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:18:32 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: Stupid VFS name lookup interface..
In-Reply-To: Your message of "Sun, 26 May 2013 08:02:51 -0400."
             <20130526120251.GA32729@thunk.org>
From: Valdis.Kletnieks@vt.edu
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk> <51A1040A.80003@schaufler-ca.com>
            <20130526120251.GA32729@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1369786675_1846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 May 2013 20:17:55 -0400
Message-ID: <4439.1369786675@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.51A54934.011C,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1369786675_1846P
Content-Type: text/plain; charset=us-ascii

On Sun, 26 May 2013 08:02:51 -0400, "Theodore Ts'o" said:

> Have any of the arguments over the proper security models changed over
> or have gotten resolved over the past six years, while I haven't been
> looking?

Doubtful, because the security models are addressing different threat
models.  If you can't agree on what you're trying to secure against,
there can be no agreement on how to do the securing.

--==_Exmh_1369786675_1846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUaVJMwdmEQWDXROgAQJFlBAAgJK5R64a6v2ce0Ha+0VxO8LbBs8t9pqt
ZkYc/KzQyO0ay+bKsAe/MvyZ5DNlEPDvBRx9J25bpSZV2oMl+Udp9vlqNtlAd55D
/xN2aL4v1b7IhCfMLWZZuyHwzV0J656vxn7RXNKAglvowiumKDau0biVJCROqswd
/lJnMzJHegACmt1zqFVcBYibkmKep5w/6kQNVkJkJpPg/IUtXKse0Jx/B+ZKchsu
PsUngYiSZSpwEg2WWmaq3a2fifEw5MZemaD8fuyMcuTm1kgp6iypY5/kFVtCKj1s
U4b/BxFUuykFrlxJgO7IeQJIF67JtvYdC9m6UkwINuLu8oaaNqQjPM7l1fQoOHo/
xG4D4W9iztSwM/0yhkf7yBIbbgmM0CmuGUFONzn/muq6On1VEdd7JUuJlyQv+RCB
5Ia3Lc+PQ6qIdqRm9FKLrHahRRTIFRMZbBEITMLPY5ekz9ggNQr7kEtS8ag72QMU
7xPvi3zUzkR2FyWzN3URqNvpS6Kvm1vO4dbYCXIR6pELyQFe4tUtQIwl2UMj2FU9
7h2wfED2Ipbwvt+Of+6kKgL+KtVR7pFnPgYUyZlYmI9YfmhHyPouztyQx7B9v65/
jmy92A+C0gWD11/oHPlIGY/q27FjUCuDg3IbgwVjZxC7A8WijVaWNjWsqfAQ0CVf
RerQecMCjtA=
=SzgT
-----END PGP SIGNATURE-----

--==_Exmh_1369786675_1846P--

