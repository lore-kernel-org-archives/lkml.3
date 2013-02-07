Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab3BGTTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:19:34 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39925 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab3BGTTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:19:32 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: next-20130206 cpufreq - WARN in sysfs_add_one
In-Reply-To: Your message of "Thu, 07 Feb 2013 13:11:52 +0530."
             <CAOh2x=mjTX3hM0uxJh9qk=9OUWqZaAjAV57r2H4AgH+ZjY+eCg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <9180.1360172675@turing-police.cc.vt.edu> <17233164.aBDzy1OViI@vostro.rjw.lan>
            <CAOh2x=mjTX3hM0uxJh9qk=9OUWqZaAjAV57r2H4AgH+ZjY+eCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1360264736_3352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Feb 2013 14:18:56 -0500
Message-ID: <3542.1360264736@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.5113FE23.00B2,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1360264736_3352P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Feb 2013 13:11:52 +0530, Viresh Kumar said:

> First of all i want to confirm something about your system. I am sure it is a
> multi-policy system (or multi cluster system). i.e. there are more than one
> clock line for different cpus ? And so multiple struct policy exist
> simultaneously.

Hmm.. it's a bog-standard Dell Latitude E6500 laptop, with a single
Core2 Duo P8700 CPU (one die, 2 cores, no HT). It's apparently able
to clock both cores at different speeds (one core running busy at 2540mhz
and the other idling at 800mhz), if that's what you mean by multiple
clock lines.

In any case, next-20130206 complained, and with this patch added I see
nothing in dmesg and cpufreq is acting properly on both cores, so:

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

(btw - I had to hand-apply your patch, as it showed up white-space
damaged.  Three lines wrapped, and tabs converted to spaces).





--==_Exmh_1360264736_3352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBURP+IAdmEQWDXROgAQIi8w//VX8FYlHTm6Kmtcaitzpe5hMzF8C3tFuB
bwjf2BsXsB1daY4JnQ+ADK/Jc1ZyNXoa832irBYGnnTFa4ewGqBby9w2PocE/OEw
5tA9e+o1gFi/S1DMOf9s5pbV6gEjf3vsSPjP7RGLIXjcj/fD0oHgvlOULWPv+JgX
Grraqkzcjuv+CIMLnJzN0ATaKpTntRQnS1kZRqhybQhDb/OoFSA6+Bo5TUyASx9K
Pep+VSSH7T93+OIv2Qw4VtW+CEtKBf/y6YQ8b2GZD4g1Jk0rRTyzTCT4UdxXy507
gWZZP5Ymg8SRcQ9oLxMh4kgLkf7VWF5gsi0lHavEYhoqLyZeK4pyc+QDBwqZ7D1S
+4Z03qG923tX2U/FrAhBszpOiDT6otl2goNDdYxgcz4kIUFr3ZXoSs8xBhRC/oTv
THGEjYX3dSNp6qNyGrhVldnkPFti4BoQVSKtcfipadzUUd7uQoaJZakqWhIkxDht
P2ErL1O5TCnzCK8ecjYZObGNjVbb17D6jJq7UVlm/2bAgnu/TOj82aj4AURsp3IE
cI4+953EKxxvMLdXO7PZVd/6Sge1VwV54rM/hCyYhEvvUjZY5u/nQ8c6+6YcemWU
3kjQoPrNz+9liDqhBfKO4Di9qC9nyYsI9+KlJhpXIiEJK3eJUunlCWk/SYMRGema
R8Eqq8y5pU8=
=e7jE
-----END PGP SIGNATURE-----

--==_Exmh_1360264736_3352P--

