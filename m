Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3A1RQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:16:52 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:46990 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3A1RQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:16:50 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: ling.ma.program@gmail.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Ma Ling <ling.ml@alipay.com>
Subject: Re: [PATCH] [x86]: Compiler Option Os is better on latest x86
In-Reply-To: Your message of "Fri, 25 Jan 2013 09:11:01 -0500."
             <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
From: Valdis.Kletnieks@vt.edu
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1359393357_2147P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Jan 2013 12:15:57 -0500
Message-ID: <26437.1359393357@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.5106B251.01A4,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1359393357_2147P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2013 09:11:01 -0500, ling.ma.program@gmail.com said:

> Based on above reasons, we compiled linux kernel 3.6.9 with O2 and Os
> respectively. The results show Os improve performance netperf 4.8%,
> 2.7% for volano as below

Am I allowed to NAK this?  What the numbers given so far *actually*
show is 4.8% more instructions executed, *not* 4.8% better performance.

I'm having a *very* hard time convincing myself that what we're seeing isn't
simply the expected behavior of loops *not* being unrolled and similar
non-optimizations done by -Os, so more instructions get executed to do the same
amount of work.

Rather than "run for 10 seconds and count instructions", can we
"run for 50,000 syscalls and count clock time" or similar that shows
an *actual* improvement?


--==_Exmh_1359393357_2147P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUQayTQdmEQWDXROgAQLcag//fsIee+NSfNUG76PoLuLDk4GG7mMRUaIC
oC/snm7QvQVZYy83dHIZr0bJPVa3H8tHCavL63pzfLwNXBC3NzNnWjHD6x/8s0ZN
FWcRun4Nn2P9QlzgUcZhxxZAnE++vMz//FNMIuuatPzNJ83uQ/Gl841lNRNYlQjb
ZxNhOmThU4Kfttj0ci3OXaLA0Yl+55uY/nZXsxlCq98g4RBo6rrkIFMrcr310/D6
cR7MW9W2zcqWZ3jIdhL/nmY6yaRBl/3czlw50rK4Rxhh4o9p+dE/FbbNVPV+BK0x
Z163S9cxLFstQs+6+nhzoEh50uNcnRhZpnEJ73L68xELV2ndFjE3Iglp+FKjsIn4
shvRqQVFJZKPsfGY/5mRbF8v4aqGSU/QQqjezUySxKZg4YvoePqzv9iDxdLKwJFC
36meM1pju7zSDe1dneEzNdYiSTy9BSRk6ezxXq+7GI4DuZez95dQExyyHf1wu3Bz
VmOEPHLbdrfE0e/r9FDK/cil8cQKRzL/4Mtkgh0ddeMWnGYEIiyB4vpmnB1G57C7
x2/xepCBM1o1x35icldAGEgpPLVLhN1U38JNpYYhtkypRLlvECmHF4gIIvSdOAEr
TojezVq5AOjAlHQdTd/VAcWFWLAFYycW8o7e0FBtkA78N+fCfriqBlYBIGvUu5df
CAHjoamNw7Q=
=g52A
-----END PGP SIGNATURE-----

--==_Exmh_1359393357_2147P--

