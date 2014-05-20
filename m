Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaETDid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:38:33 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36708 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaETDic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:38:32 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>, Petr Mladek <pmladek@suse.cz>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>
Subject: Re: [RFC PATCH 1/2] printk: Add context information to the header of /dev/kmsg
In-Reply-To: Your message of "Mon, 19 May 2014 19:28:38 +0900."
             <20140519102838.30455.86863.stgit@yunodevel>
From: Valdis.Kletnieks@vt.edu
References: <20140519102835.30455.10437.stgit@yunodevel>
            <20140519102838.30455.86863.stgit@yunodevel>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1400556970_1944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 May 2014 23:36:10 -0400
Message-ID: <11176.1400556970@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1400556970_1944P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 May 2014 19:28:38 +0900, Yoshihiro YUNOMAE said:

> The header information is changed as follows:
>    <prefix>,<seq#>,<timestamp>,<fragmented>,<PID>/<interrupt context>;<msg>

Has this been tested with popular userspace that reads /dev/kmsg, to make
sure that it actually plays nice with a 5th field being added?  Yes, I know
that Documentation/ABI/dev-kmsg says that added fields should be gracefully
ignored - but we all know how good userspace programmers are about that
sort of thing. :)

--==_Exmh_1400556970_1944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU3rNqgdmEQWDXROgAQIRsA//V2f7QX96ca2NkFPKxUTOOBZRjJHG5MaB
5QeKdKEtZXxM1pLaWWaAGv0fZkzKjkhzSICgah+Cy0OwlW9WdcYWGhduV2j9yVTf
KYcznFQFArsxPQL9/zXvEkE00VSB3vua2ts+Fr+l0UCKO10QgvurMZ6LKRhR89B7
HxfqYxiFzCHqDa7kWhDSqJn8HQ6hD3L1ie5ZPJ+z318ZcMTFtHCnKAnLKguhXH7J
QqqZWSUbdkiqZwNSxzZ5ZaExcjmj3RIlY6WPo5Mf2i2A5uy/DADptEUdy/vs2f34
DL7YVxYbiMRGXvkWPn5MGYtk39XemnvSvQXAudEwlgMHScguMcxkgaAIKRB8JW1f
5yRBzwqJGtGAlfq2FHXR+lxoe95XqsineRDrmRpj46EV11qnDTTMM3DnndSDHYYW
5G0n8jgGSAkFwSNKj1/8r6ZzKduf37BLlnsWPlkVNRs6we0pGOCC9lnvy8ghHDfz
j7AAgTk44MyUIgxSNwCSTjX0o9T+EqcCRrOu7Jm6apdAmJhxPK2Zdb4EOsz4lddp
FWkCOt1l+G9TMxEHFroWv+wP9BZIVwR7bsfuCMFKizrxLyzkeIel8PDJEbrZ7Vzx
lywc5WJGmCXTYWM/ZE05lfudTici2XDX8rZo9MkT7NhoHfgYsaWCYhyBZTT99v3j
ytD7F9VwE60=
=9pjj
-----END PGP SIGNATURE-----

--==_Exmh_1400556970_1944P--
