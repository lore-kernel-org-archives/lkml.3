Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab3CHNn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:43:59 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:58585 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab3CHNn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:43:58 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: next-20130306 - BUG: unable to handle kernel paging reques in avc_has_perm_noaudit
In-Reply-To: Your message of "Fri, 08 Mar 2013 11:15:47 +0800."
             <513957E3.8000406@huawei.com>
From: Valdis.Kletnieks@vt.edu
References: <3077.1362687651@turing-police.cc.vt.edu>
            <513957E3.8000406@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1362750226_9938P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Mar 2013 08:43:46 -0500
Message-ID: <44447.1362750226@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.5139EB15.01D8,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1362750226_9938P
Content-Type: text/plain; charset=us-ascii

On Fri, 08 Mar 2013 11:15:47 +0800, Li Zefan said:

> I don't think so. The commit changes cgroup_rename(), but the above stack doesn't
> sugguest it was renaming a cgroup directory.


OK.. I'll go bisect it then.


--==_Exmh_1362750226_9938P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUTnrEgdmEQWDXROgAQL0zRAAg2tqZ09NArskycH+fOduOjL2hkXiRgZd
IJDwO//nvoSfpAJp5yTQEmXP3NlnnUmuVpwZ7R5aBCHtpdgcnA3tvE+15QT0oCSo
0JCfK0AisO624L3DgRJsXCQKT6Wd9DqeSbTHXpbeVCQaK6UV2FXH+74ehUXyPFCe
BZTmyyX/H8GVGVR1nYfPixyClZ0esbB+AhGA1STr3t2ygE1m5dr45AQW+xv5gtN2
FgbcID2GYrOgKO9FWCMVoMSrGyGPSmbzl84qKs/D34u5DefyWZpIsnqc/LdgJfoC
u1Z8UP10bz7edk+cmxocMt3tHDgOXuCQHH7HDX3O5GUbme+hlQoaPTFCSU00ezaU
7YGmCoAf2qK4V5QnSIaa0MpbnmeV7UFmL6ZX/KkePDI0Ppok3nlED5zHjm57VLII
1WCkgUo1qHKsUnZls48NAigOUylfteJKFkFmRrVfFqO0fAZiCR6a7Hbza4h4qB39
b1tZv40L5TRTmNcUPBPNUmCaxQaPVkxxuti7zIdptzjUAhLq175Uoj648Y7imCrf
FtNToAe5or32A1VtdvK1pUYd/2MCgi3gAp2EcykhWHdBByqDqyRcABuu5tjWeMRC
fAdlMdSEUUZGQ2zQnCGcuorSbmyNx+D3RJ7oseNaYmGz8f8aHDX1SjdZs6pbSZlk
4YjvKGIzL4k=
=6Liv
-----END PGP SIGNATURE-----

--==_Exmh_1362750226_9938P--

