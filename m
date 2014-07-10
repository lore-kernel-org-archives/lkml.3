Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaGJRIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:08:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47906 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaGJRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:08:15 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH06/17] PKCS#7: Verify internal certificate chain
In-Reply-To: Your message of "Wed, 09 Jul 2014 16:16:04 +0100."
             <20140709151604.23074.4848.stgit@warthog.procyon.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
            <20140709151604.23074.4848.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1405012013_1990P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jul 2014 13:06:53 -0400
Message-ID: <42827.1405012013@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1405012013_1990P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Jul 2014 16:16:04 +0100, David Howells said:
> Verify certificate chain in the X.509 certificates contained within the PKCS#7
> message as far as possible.  If any signature that we should be able to verify
> fails, we reject the whole lot.

What happens if we see a signature that we shouldn't be able to verify?  Or should
that changelog entry be reduced to "If any signature fails", period?

--==_Exmh_1405012013_1990P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU77ILQdmEQWDXROgAQIEhA//fiRlRWKdpDN4wMfdQt/AjjmA6GFQbpQW
VKzP/NKa+fTpdoHF6wHn2p9DybIhETi8qDFTtNQHkhVt6phixkpg5wntDsxVwM3t
f8njUf/GDkf5eTvB9znjzqnaz0T+swTdU4ISs71XTHDXqNp6Ei3RT2Ml+v8sS/q7
aXz3UkV3JaUbMWfcjzpVG6kapk4YjXiG+JBbzqnYe3OpYwN8tyDtlK0/sJQIAAzg
WryFaPPq5T5tNPDjMylnI40KgRdgJH2EOyNlasQJ8hHDLDs1EkpHEPj7P9jEJgw0
s7MBxbOvtBlRKjNBzmrWgntuLH+Y1h0sGHQ6TsdSH+dcMSh/Zyw7EnwmEo9kvWmv
YNMP+J514NQU6eC8/91bzhvMumylJMo+tqfadvcU2w/gYHRJoEU6v0dUkGkefnzC
BhcbKprM/7mR4F+i5GwPVmn7ZBDlAP3dG2bt0T/1Nfh5D0wq1nli4aPKSj1Aknym
55YLRbL39hC2QdJJkyLzAVg80YnAhE9nSD98DYmu23diG1TcsC5aqesdPoFEWWlw
69T+h2/+X+c2S/cdkb5iiuIdimbI9ZCQBRPGTOwqevkJC1T16YIsQSlFpnBKNNeO
SQkazvv7LXuCaMtB7HfynKm3CqmrQfKC+aHk9NJzDR4+FrcITgHKj4YdOOxA+lIQ
bildNXpZh/o=
=Lihv
-----END PGP SIGNATURE-----

--==_Exmh_1405012013_1990P--
