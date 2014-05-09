Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbaEIS1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:27:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36883 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbaEIS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:26:58 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: next-20140409 Bad Kconfig help text in drivers/acpi/Kconfig
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1399660010_2033P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 May 2014 14:26:50 -0400
Message-ID: <25850.1399660010@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1399660010_2033P
Content-Type: text/plain; charset=us-ascii

So this commit landed in linux-next recently:

commit e2a7c3d7812369daae56f069eab2e8f3e548d231
Author: Lan Tianyu <tianyu.lan@intel.com>
Date:   Sun May 4 11:07:24 2014 +0800

    ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"

    The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
    directory and breaks some old userspace tools. This patch
    is to revert 7d7ee95.

    Fixes: 7d7ee958867a (ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c)

The problem is that it really needs a follow-on patch to fix this help text:

    This option has no effect on /proc/acpi/ directories
    and functions, which do not yet exist in /sys
    This option, together with the proc directories, will be
    deleted in 2.6.39.

Somebody want to pick a new release target and try again?




--==_Exmh_1399660010_2033P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU20d6gdmEQWDXROgAQIQhQ/+Otc5V5YtX1Mx0+lcNo5lzM2SHbxKiH2/
NXo7uRZ20uLaQq0DJm0bZRAgOvJjURnCQ7pbUQVNNwvZzQ96J+UBcaBD83cSTAqP
TRcSSzhYowhaR1m3Q7RsFPbuAhLlinRzfhdoRZLoaC/aWwj/xwVNjo7ci7eVvVOm
VAILfK+We+nNzlseXTHUj9Fxn5NIQZ99k1bCR86PCNcpO6CzBY92tsz4OZ1AVPGQ
qkc6tIiNRz8AAw1OGiraFjdsPA1WOJEhHxeFSQv2SQVTtTFVUUUyiHPAabZ+ndar
WB2ruxmlDtRkOLcx5PFZQpzthYM35sfOgs8j022lpU4yxkbtCqcl9X/kCX5ifKmM
wIp/rfxSbg+uTqdAo2lpWiVY45fZYZoPj4Dqs8qUNVP6u89bOipi+XN0bUysnsqd
LhqOGPfqN91hRcS20cpTLtn9LQIc7y6V2RVaOmJysJxN3r7GcMIiHyishhbGGm98
uOBgnnrovqoMkvj0THjQ2TcyCzJcmrOVNsS/wLUzhLPrDGhSMZz88LgI+tXZ1wCI
w8LX4+6f0Z24jiEoBD6i0cg+U5LOHWYdHgv/hyu2gNV/VxC1U8Wrr71qdI7l7K+/
L5QPBvX3NO+KkHqb8QuixYBz3UsUD5U1jJOFCRpRh5h3pRMsZbBbweB+ujK3bFV8
4xtc5B7OpXo=
=A+vv
-----END PGP SIGNATURE-----

--==_Exmh_1399660010_2033P--
