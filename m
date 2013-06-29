Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3F2OCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 10:02:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56323 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3F2OB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 10:01:58 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: mmotm 2013-06-27-16-36 uploaded (wait event common)
In-Reply-To: Your message of "Thu, 27 Jun 2013 22:30:41 -0700."
             <51CD1F81.4040202@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <20130627233733.BAEB131C3BE@corp2gmr1-1.hot.corp.google.com>
            <51CD1F81.4040202@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1372514416_2179P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Jun 2013 10:00:16 -0400
Message-ID: <65029.1372514416@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1372514416_2179P
Content-Type: text/plain; charset=us-ascii

On Thu, 27 Jun 2013 22:30:41 -0700, Randy Dunlap said:

> +		__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;

Was this trying to do a  wait_ho_timeout(!!tout)  or something?

--==_Exmh_1372514416_2179P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUc7ocAdmEQWDXROgAQJnsw/9GIls2RIxjfNdU10UXmU5XtVGWfAu2IkZ
lO5FqDzA9b+g49K1HLAxQ3RVNz+TrtmI44gx6qjzsMYqVzz4KU5KRzgd+yAp5M83
WK2oI7ez0djtOLst6NnPddBZN6Li8x6h8UaW6CltpR2qRcCyZvF22SqAzVDWXClo
kc3sYTIWDrfPnAvpBEpJpTPl64i7G5nLIri+Vx4UnsmXVeRUKhKk1og3ekdZJ6os
BtkKU55WlJEidalOV5NeyZ9SVPlGTptc1GhbYnB7dGuMWzpdNtqQec+VnQRLQNOz
FnTTzWNI5vSEYB4sSLwawa3JE3l/Xq+ZMwI2/G6cVjH1kc4hEw+gD8Si3+wdj8rA
mg/ski9wqSMLOirXduqOxzNsdvSR92bLKMz8ZBKXirtb1EWyxhs7tyA1HDYN9gfi
VTpdtYbI4THRCKTB6z/2ToCqEEeXmfBl3TE8DYzervaz1fHxbHjIGpEstWyOdBLj
ZqUCPQ60BsQrqT2Xdg5opi0yKMFbDL6Hfce4Wk/hXE50AkInFtRqg10HwgQaPj2U
UXW+A/lBt0UyjUnvcg4y8fiUt25xcIPojn1stwi4Vm4fpMwCS7OmZ6RkCiyB5wXH
It2s71pSzAifn0OUdI/ZlDxkdUYBHGpz87aU39ze5ZazUiCIP+D7N3ywmKOnsCmD
ryOFZ7EiecU=
=6+DB
-----END PGP SIGNATURE-----

--==_Exmh_1372514416_2179P--
