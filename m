Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3KOVAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 16:00:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab3KOVAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 16:00:34 -0500
Date: Fri, 15 Nov 2013 15:00:06 -0600
From: Clark Williams <williams@redhat.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Jim Somerville <Jim.Somerville@windriver.com>
Subject: rt-tests v0.86 available from git.kernel.org
Message-ID: <20131115150006.004c01a3@sluggy>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/e9KmgWLvnJdRGykGS+fPV.h"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/e9KmgWLvnJdRGykGS+fPV.h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The latest version of rt-tests (cyclictest, hwladetect, et al) may be
pulled from:

git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git

Use the master branch or the tag v0.86.

As soon as kup and I come to an understanding, I'll make tarballs
available from my directory:

https://www.kernel.org/pub/linux/kernel/people/clrkwllms/

This release is mainly bugfixes, but two new things were added.=20

Nicolas McGuire added the -A/--aligned option to cyclictest which starts
threads aligned to a specified time boundary.

I added the -F/--fifo option to cyclictest which causes a named fifo to
be created so that an external program can read run statistics while
the run is in process. This one is early days yet so any suggestions,
corrections, flames, etc that can improve this are welcome.=20

Here's the changelog:

* Fri Nov 15 2013 Clark Williams <williams@redhat.com> - 0.86-1
- cyclictest: allow break threshold without doing any tracing
- cyclictest: add named fifo for statistics
- from  John Kacur <jkacur@redhat.com>:
  - cyclictest: Align option fixes
  - Makefile: Don't tag files in dir BUILD from rpm builds
  - Makefile: Add BUILDROOT and SPECS to the dirs to remove for distclean
  - Makefile: Add tmp dir to distclean and "make release" call distclean
  - Makefile: Don't tag tmp files created when making a release
- from Nicholas Mc Guire <der.herr@hofr.at>:
  - cyclictest: add align thread wakeup times option
- cyclictest: modify option handling to use enumerated types
- from Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
  - hackbench: init child's struct before using it
- from Jim Somerville <Jim.Somerville@windriver.com>:
  - cyclictest: finish removal of 1 second first loops
- from Frank Rowand <frank.rowand@am.sony.com>:
  - rt-tests: NUMA optional for make rpm
  - cyclictest: white space cleanup

Clark

--Sig_/e9KmgWLvnJdRGykGS+fPV.h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlKGi1YACgkQHyuj/+TTEp2ATwCfc8V3m+i/JAuu0p2YX4C6wxjo
ufkAoKKP2Hb1rbOxnf5UOPcxXxzeRI4a
=zGmj
-----END PGP SIGNATURE-----

--Sig_/e9KmgWLvnJdRGykGS+fPV.h--
