Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaDDAnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 20:43:47 -0400
Received: from imap.thunk.org ([74.207.234.97]:49728 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaDDAnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 20:43:43 -0400
Date: Thu, 3 Apr 2014 20:43:39 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Subject: [tytso@MIT.EDU: [GIT PULL] /dev/random changes for 3.15]
Message-ID: <20140404004339.GA2525@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Whoops, sorry to cc LKML.

				- Ted

--jI8keyz6grp/JLjh
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <tytso@thunk.org>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 03 Apr 2014 14:48:20 -0400
X-Sieve: CMU Sieve 2.2
Received: from mit-mailsec-scanner-7.mit.edu by po14.mit.edu (8.13.6/4.7) id s33ImKqw027544; Thu, 3 Apr 2014 14:48:20 -0400 (EDT)
Received: from mailhub-dmz-4.mit.edu ( [18.7.62.38])
	by mit-mailsec-scanner-7.mit.edu (Symantec Messaging Gateway) with SMTP id C6.F0.02534.3FCAD335; Thu,  3 Apr 2014 14:48:19 -0400 (EDT)
Received: from dmz-mailsec-scanner-5.mit.edu (dmz-mailsec-scanner-5.mit.edu [18.7.68.34])
	by mailhub-dmz-4.mit.edu (8.13.8/8.9.2) with ESMTP id s33IgKEY022097
	for <tytso@mit.edu>; Thu, 3 Apr 2014 14:48:19 -0400
X-AuditID: 12074f12-f79726d0000009e6-90-533dacf3fba3
Authentication-Results: symauth.service.identifier
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97])
	(using TLS with cipher AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by dmz-mailsec-scanner-5.mit.edu (Symantec Messaging Gateway) with SMTP id 1C.88.04954.3FCAD335; Thu,  3 Apr 2014 14:48:19 -0400 (EDT)
Received: from root (helo=closure.thunk.org)
	by imap.thunk.org with local-esmtp (Exim 4.80)
	(envelope-from <tytso@thunk.org>)
	id 1WVmgU-0001HR-Jg; Thu, 03 Apr 2014 18:48:18 +0000
Received: by closure.thunk.org (Postfix, from userid 15806)
	id EBC77580C37; Thu,  3 Apr 2014 14:48:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=thunk.org; s=mail;
	t=1396550895; bh=DT8qr31J/I5fLuPNsOo3E92srNNPY4oz/7PAgZFSBYc=;
	h=Date:From:To:Subject:From;
	b=Dctcd1nqLgOs9iXGai2cqG/iV5FkE5vwftCuoBsD5KFz/NYdLezmkOUS9yN2xWw0o
	 vkqUqw/bv88jntRc/SQTzlbhSx8Ghn5T0O2as5esWjpZWzxCwjNfSUh30yG/PMYgLa
	 Clr4kwcwikiQ/UaFJbO0fhgQAhR01piPP9O4HZMU=
Date: Thu, 3 Apr 2014 14:48:15 -0400
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] /dev/random changes for 3.15
Message-ID: <20140403184815.GA2721@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
X-Brightmail-Tracker: H4sIAAAAAAAAA1VSbUhTURjeuXcf1+mVs6vmaWrZsFBhaiFUmtqPohLESCGIIG/u5GbbtN1p
	W0GIZoWZaOAPhx99mfmBqZlIEuKoH5roWCqWWRgSbWZWauEPrXudX/173/d53ud5Xs6hSMYt
	UVLYYsYmI6tXSeViRpa4Rz3fkpAW01Nz8EBx6ZLsMDheOPiaPAnOyA9psF6Xj03RiRlyreNT
	Jcgd9rXcXHwACsCwdwnwohCMRW/qFsSeehtyfHwqLQFyioEvAappK1xrxgC6Xt9Orm8MOipk
	Qg3gPtQz5JZ4SI8IVDX5jPQ03QC1T4xJBBYDOdTrahYLgBhOEaj0xy9el+KbMFTktAocKdyN
	Opv+EkLtz6vOfx1Z3fWDMah+9j0Q6DRUI0d9sjCmoQL1V02vxiZhJBpfcREChYRBqGGFEsYB
	vPhI+azMkzkC9Tk71q4MQ31tf9ZuSUZzXU5CSIbgrAyNPZ6UloNA2xYL2xYL26bFPUA2gRCD
	zqw2sDo9hzPVXCZrNGKTen8UP43CmrwOsPo8qUw3WHTusANIAZUPnaFLSGMkbD5nNdjBdopQ
	BdCSRn7kez5HY9WynPacKU+POTtAFKnyp4tv8BitYa1XsClnHQqixKpAevjIRCoDs1gzvohx
	Ljato8EUpUK0kv8SjMKEs7Dlgk5v3oQJyksQ9+HFRQKH5nJZA6fL8uADYJcykB5t5gEoANo8
	48au8N2Sh92sE4Qo/WggEokYH96XP/d//DNQUC4ZI5UT2AjDlWJjjhG7QSB/vh+9ICj76Izm
	DUc3H4bgw3i3xglhzOwmpCwA9FD0NUdEv6VuRv3cNTfaezplcblnYCY+eO6FLwj/gH/e+lJR
	2tRoafj99gmh+qZYchIw3V5Q5J5xxnqV6d9dDT2xrP/+qow71ZqQnX7WcXvAt3ZlxBq3c/qh
	LUl/rC5PU305u/poUnX2nZI+jftSaMtUSiesYmvvj3fFV7ruqsSclt0bSZo49h/0eT6jfQMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRWlGSWpSXmKPExsXidf5Vou7nNbbBBn3nRS1ae36yOzB6NJ05
	yhzAGMVlk5Kak1mWWqRvl8CVceH+VMaC83wV7V8XMTYwnufuYuTkkBAwkThzYSI7iM0oYCSx
	+9wrVoi4mMSFe+vZuhi5OIQEljBJzLy7mRnC2cEosfH2NbAqIYFiif0vV7OAJFgEHjJJ9Hz4
	BNTCAeSoSDRfqgSpYRNQlrg79zQjiC0CtOHziytgvcICBhJL395iBCnnFdCVuLDUCyTMKyAo
	cXLmExYQm1lAS+LGv5dMICXMAtISy/9xgIRFgYZfmfCWHeJOTYmDlzaxQNgqEgc3fGeGsL0k
	3m+7xDSBUXgWkqmzkEydhTB1ASPzKkbZlNwq3dzEzJzi1GTd4uTEvLzUIl1TvdzMEr3UlNJN
	jMCwFmJ3UdrB+POg0iFGAQ5GJR7ehEzbYCHWxLLiytxDjJIcTEqivKwrgUJ8SfkplRmJxRnx
	RaU5qcWHGCU4mJVEeFvbgHK8KYmVValF+TApaQ4WJXHet9ZWwUIC6YklqdmpqQWpRTBZJg72
	Q4wyHBxKErwPVwN1CxalpqdWpGXmlCCr4QQRXCBreIDWMKwBWVNckJhbnJkOUXSKUVFKnPcq
	yAQBkERGaR7cAFgqusQoKyXMy8jAwCDEA3QB0OOo8q8YxYGeFub9AjKFJzOvBG76K6DFTECL
	uddZgSwuSURISTUwzo8OmvfwGw+rmGNZa6DUHqmSFPWOBavvNUra/zSfLj83eL7INXcW7m3z
	rc7u8fib/U/OZRKb3sX5DCvuzE3jMKxbH1EXXjrrKdPMug+nFnNNDfw4LVP+X7FpgHWC4/y7
	8q/nFEzL+fDZzZN1zduDxYkMU3OvR6aeWSqc8LL6UqvxxHcbqtseKrEUZyQaajEXFScCAGaD
	rg1AAwAA

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to 7b878d4b48c4e04b936918bb83836a107ba453b3:

  random: Add arch_has_random[_seed]() (2014-03-19 22:24:08 -0400)

----------------------------------------------------------------
A number of cleanups plus support for the RDSEED instruction, which
will be showing up in Intel Broadwell CPU's.

----------------------------------------------------------------
Greg Price (11):
      random: fix typos / spelling errors in comments
      random: fix comment on proc_do_uuid
      random: fix description of get_random_bytes
      random: simplify loop in random_read
      random: fix comment on "account"
      random: simplify accounting logic
      random: forget lock in lockless accounting
      random: tighten bound on random_read_wakeup_thresh
      random: simplify accounting code
      random: entropy_bytes is actually bits
      random: clarify bits/bytes in wakeup thresholds

H. Peter Anvin (4):
      x86, random: Enable the RDSEED instruction
      random: Use arch_get_random_seed*() at init time and once a second
      random: If we have arch_get_random_seed*(), try it before blocking
      random: Add arch_has_random[_seed]()

Theodore Ts'o (1):
      random: use the architectural HWRNG for the SHA's IV in extract_buf()

 arch/powerpc/include/asm/archrandom.h |  18 ++++
 arch/x86/include/asm/archrandom.h     |  42 ++++++++-
 drivers/char/random.c                 | 244 +++++++++++++++++++++++++++---------------------
 include/linux/random.h                |  16 ++++
 4 files changed, 211 insertions(+), 109 deletions(-)

--jI8keyz6grp/JLjh--
