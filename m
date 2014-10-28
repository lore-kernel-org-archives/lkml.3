Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaJ1Pyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:54:33 -0400
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:34852
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJ1Pyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:54:31 -0400
Date: Tue, 28 Oct 2014 09:54:28 -0600
From: Kevin Fenzi <kevin@scrye.com>
To: Yanko Kaneti <yaneti@declera.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cong Wang <cwang@twopensource.com>, netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        mroos@linux.ee, tj@kernel.org
Subject: Re: localed stuck in recent 3.18 git in copy_net_ns?
Message-ID: <20141028095428.15cadd01@voldemort.scrye.com>
In-Reply-To: <20141028130002.GA1682@declera.com>
References: <20141024230524.GA16023@linux.vnet.ibm.com>
	<10136.1414196448@famine>
	<20141025020324.GA28247@linux.vnet.ibm.com>
	<11813.1414211613@famine>
	<20141025051602.GB28247@linux.vnet.ibm.com>
	<15891.1414255096@famine>
	<20141025181827.GE28247@linux.vnet.ibm.com>
	<20141027174539.GC27568@linux.vnet.ibm.com>
	<20141028081243.GA32082@declera.com>
	<20141028125059.GO5718@linux.vnet.ibm.com>
	<20141028130002.GA1682@declera.com>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/.y+M9QmDo4qm3TvHqld=UHP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.y+M9QmDo4qm3TvHqld=UHP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Just FYI, this solves the orig issue for me as well. ;)=20

Thanks for all the work in tracking it down...=20

Tested-by: Kevin Fenzi <kevin@scrye.com>

kevin



--Sig_/.y+M9QmDo4qm3TvHqld=UHP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJUT7w2AAoJEEs3sNgP+7teNREP/A/eQC08k96aE87UIGfKsDPL
7h9ccuOGSqf4LveycOhBOHGgocy+YLv9jOoNMBeIEBUc/7vhu13udCCeL1XQRkJK
HSaqXksdXDYCAKdRsEgEK2aduMBO/b8TdcrM770qLHdqtCxALy8M+SeIiNtSeFHt
IFmZHDx7Nkf+cI+OmUS1sijMDP0PcN6VF9dqapRPFft22wmk4OOruM03czF8seze
Ck0zqXZ/xYvkN2fMAwSUiyJFNGqhPSKqzmRHy/51/os6dIwHSupOyqKq6RERKa3e
qZUP6BEhGAkhVJJ26rmzWmMijrXpasgtjdYiOS8Ez5w3mzerij0kXp7Qyk18PRwR
3T0U00KzSd3cwmk3B3W4/fe7/ZtgXo/kDml5wjAcWwl4tMUv6MV/9hFaCWL8foC4
zG3rnG2EQcsYBiJtWZGlRDNzk2XngmJsA6Xb277GedhluVe4KBaLBwDKieCkZ8en
oRelunFgATZy7iXEV338lg0HwrmfWOEKpLGiAGCsYIaIdw2L18Psymf2FDa11se8
xG0zZ3kx53wJZHVW0b8wQztSn8Ci1U5eNVSunjK/efmeWYWx/1VyXR6YBlb6MU7n
5eJpIBcmqIyVuet3IVppsdR9I76G+5Aku/Jd4/05DiqlqzXjXo9l6flRQHsMaBWN
8bcm9+2IHvUaysQNP2+V
=hM20
-----END PGP SIGNATURE-----

--Sig_/.y+M9QmDo4qm3TvHqld=UHP--
