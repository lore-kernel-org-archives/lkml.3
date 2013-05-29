Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab3E2ALo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:11:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38907 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3E2ALm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:11:42 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Christopher Sacchi <christophersacchi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: Definition for loglevel in KERN_OOPS
In-Reply-To: Your message of "Tue, 28 May 2013 20:00:45 -0400."
             <CABQQNFGaS9rKaWto75fVQ5Ru+XKU2hgBRBjnV8G6WGf_TeMt9g@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CABQQNFGaS9rKaWto75fVQ5Ru+XKU2hgBRBjnV8G6WGf_TeMt9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1369786271_1846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 May 2013 20:11:11 -0400
Message-ID: <4136.1369786271@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.51A5479F.0100,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1369786271_1846P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 May 2013 20:00:45 -0400, Christopher Sacchi said:
>  This patch is for linux-3.10-rc2 and adds the definition for
> KERN_OOPS (it can be used for whenever kernel oops occur) in
> <linux/kern_loglevel.h> for <linux/printk.h>. It is below the
> double-dashes.

OK, I'll bite.

1) Where in the kernel will this actually get used?

2) Are there any matching patches for userspace tools like syslog
to make it useful?

3) Was it intenional that you added this:

+#define KERN_OOPS         KERN_SOH "2"          /* kernel oops condition */
instead of
+#define KERN_OOPS         KERN_CRIT

4) How does a syslog daemon distringuish between KERN_CRIT and KERN_OOPS?

In other words - why do we need this patch?

--==_Exmh_1369786271_1846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUaVHnwdmEQWDXROgAQJubA/+POlYPXaRokBUEkjIo+VE4XFHQ5W8wQtb
LZhkLkzuatdeGeryl1xXe2C3na8Ih6OoQmtAqrEk5LNAHpRs/fajJDchVwb2nqur
he3LWnZUhD3dwvUYL06idIiMxvTaQHS6EMQeWIuVvcUQ20xnRk115buy9NCFnp7s
/vrfQMS7NyY3J6fv70e2qKLWlUBzCRr/OvtfP+FiDXXU9pUPpDtEBdJ5XmEgXdRk
TvLYHanQWJaIx6YXVZxJ/yZxuBpniQOa67D7AXX1P8TlYi9U0GiyM8erKWTu++GW
QiBkz0rcMjvyUImQOq48E0jaEYSkCk3t95bybGsBq/xV6plH8p9UtU19vrGIO+PM
q1CeH9MZqcMsBpE6YkQFysgV+/a5wbMkNqDipBd4ELsT4Hb0UcO5YEP3T8HD8CZz
/6y4WbxPkmeJtbMdxQe6RjEXYtHOHHrhrcueoBAkNWjbgFe9PiH9EfMGbZFn3tqb
3Xio0JerWtEiompyDAtrVBCs/o/AuimdGMvCkdVjvjbzpHeLUNkXeWGEsizHlE/N
Dm7L09SeDekfVh4UNfz9uavC12+PEWa4n/W8NqOwtoCQRgefZtZ0of8UvVr+BjdJ
iSDM5g+DLT5nZYkCOA4Y+xAcB7/bFYnzRByCdpRJE1dxTKNqd+S/u3gaSKCBnhsW
eCQSm5z2wOs=
=rO9+
-----END PGP SIGNATURE-----

--==_Exmh_1369786271_1846P--

