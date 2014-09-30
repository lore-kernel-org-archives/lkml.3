Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaI3JpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:45:16 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:36583 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaI3JpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:45:13 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
In-Reply-To: Your message of "Thu, 25 Sep 2014 16:33:17 -0400."
             <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1412070301_2231P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Sep 2014 05:45:01 -0400
Message-ID: <15705.1412070301@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1412070301_2231P
Content-Type: text/plain; charset=us-ascii

On Thu, 25 Sep 2014 16:33:17 -0400, Matthew Wilcox said:

> Patch 19 adds some DAX infrastructure to support ext4.
>
> Patch 20 adds DAX support to ext4.  It is broadly similar to ext2's DAX
> support, but it is more efficient than ext4's due to its support for
> unwritten extents.

I don't currently have a use case for NV-DIMM support.

However, it would be nice if this code could be leveraged to support
'force O_DIRECT on all I/O to this file' - that I *do* have a use
case for.  Patch 20 looks to my untrained eye like it *almost* gets
there.

(And if in fact it *does* do the whole enchilada, the Changelog etc should
mention it :)


--==_Exmh_1412070301_2231P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVCp7nQdmEQWDXROgAQLv+Q/+MJrrdItGQo9RwAqKyVmn7uJA2UWWmBJ2
8otETBMl0IQHv+JHbQTUynXMD6AgKpBrAjkW56dTVc5XhnHIwR7ZzYfriYmp6jpe
TdNb3iYP1zpKbixfHSCIhmacmJEk9tNYJdSTH1RKagFGM7DRA3LaG5A3PvEr/RGZ
NpMgADZDUA3AbDT0CQkBVGJ5Y6osPAVq/fD6S0vyvUsmLAVsrtpYMPsJXXh6NaNw
5qoFjnBNkopPVIDY0vqcqJgNUC0bVRtgkrxhiwDnhzxVdz+qOAri8GbiHkKzAhB+
iXIbxUl+IH+BVAgmrMZPJA3MDr4U1bCj+dfNlfYI+Mgubm1hzSQEf4re9wcVjWiG
lyV2NpxhQHkV1P+nw0gVvGd8e5qOWd2WLMdqo4UOGeUSYukhlR4BrkUs8FVt/4Jh
a/nWascldQ4Lap270vrHRN8oKp9VRz8WoIqzugOg3Nuhtplg6bol5p6y3HnaCUFI
dclwFW3OT0dDWODZFzXdOZQfCDoEbDwP0Zbk6C42XriNgm7cHEv4Mr06aahC81zo
/oCZAosXBy61k13hKxRbDR4AHen1oEW/rKNlzhviOCbiIfk2eIrpwgSWtaKRyU5b
nAvNr0JrjjmNG+K3AftGxa5wPl+cU1lSYM2gKYiawTH5210CbwfCSQ6j+1q4l2ch
EMrC7MqtG0o=
=q9v8
-----END PGP SIGNATURE-----

--==_Exmh_1412070301_2231P--
