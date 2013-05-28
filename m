Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab3E1DiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:38:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52420 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717Ab3E1DiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:38:06 -0400
Message-ID: <1369712253.3469.426.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 1/6] mm/memory-hotplug: fix lowmem count overflow
 when offline pages
From: Ben Hutchings <ben@decadent.org.uk>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Date: Tue, 28 May 2013 04:37:33 +0100
In-Reply-To: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TOzbzShQt1fbFomBxQ3Y"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TOzbzShQt1fbFomBxQ3Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-05-26 at 13:58 +0800, Wanpeng Li wrote:
> Changelog:
>  v1 -> v2:
> 	* show number of HighTotal before hotremove=20
> 	* remove CONFIG_HIGHMEM
> 	* cc stable kernels
> 	* add Michal reviewed-by
>=20
> Logic memory-remove code fails to correctly account the Total High Memory=
=20
> when a memory block which contains High Memory is offlined as shown in th=
e
> example below. The following patch fixes it.
>=20
> Stable for 2.6.24+.
[...]
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
[...]

This is not the correct way to request changes for stable.  See
Documentation/stable_kernel_rules.txt

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-TOzbzShQt1fbFomBxQ3Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaQmfee/yOyVhhEJAQogSw//SSffy01Q+MbGAuMdzn3v5tOEtbUSnag7
R5mM/VHrt+wg+IlcUYSHvL20H7O+CDpk7Rg68U+B37x0Nnk/00YgE+lsQrnl4KW7
1SkvvnXLw1J8wT70mbggOUVKPLPNhW2+wGTdpXJnxeGExneEiJC09nD8rqhgdCXx
CzTcnPCI8bKpIAQ6dKvf1d4xeaL6xf4EujxItNLVNg0hKeoJ3mDfd6Rz7GG3IiTi
NB7XIqsQgf3ATmbt8Mje6uaC0Er/K/Lt4EmwOFZG//30y+kfeoa6jY0b8VLvF0/b
NQYW55cR4uj2LM0oL0iEsziB7tVh4Q3Z+C9htp3GC31HejknpPow++BUP3Kpw6Cn
LlNQRWZszAgZjPWWUJahRjrNpD/UAM8PI1VZyHtw+oVHxX7cl7oRXvHntvdp2MF7
lerBRldIfBRh9nV9HyyWXLyxWLuf0qvWdfp+Q5g8wXn8I+tDSucIQ/lYs2yhjNnK
EYfVCTrVZSZG+Ppe370cD4EQCZ2qpf3J0t1upcY6p4aOHcbfrt0DT9r4Q9GDZFeo
ob1xjHD3BuqxR3Sl+ngDg8eDEX0U2L8JNth6z476Giw+/gFreidgbAoFkmJHJYUN
DhZd2tIU6Sw6YHctDxp56WgOsWGKLMUK/4mG/J9lFj9+2f9+EAR7yl/I3hqoTRN0
sUsUZKi2Sz0=
=oad5
-----END PGP SIGNATURE-----

--=-TOzbzShQt1fbFomBxQ3Y--
