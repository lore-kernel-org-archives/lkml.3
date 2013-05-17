Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3EQSZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:25:30 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44843 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754780Ab3EQSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:25:29 -0400
Date: Fri, 17 May 2013 19:25:21 +0100
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kmemleak patches for 3.10-rc2
Message-ID: <20130517182521.GA31129@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Thread-Topic: [GIT PULL] kmemleak patches for 3.10-rc2
Accept-Language: en-GB, en-US
Content-Language: en-US
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the kmemleak patches below. Thanks.

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/kmemleak-fixes

for you to fetch changes up to 89c837351db0b9b52fd572ec8b0445a42e59b75c:

  kmemleak: No need for scanning specific module sections (2013-05-17 09:53:36 +0100)

----------------------------------------------------------------
Kmemleak now scans all the writable and non-executable module sections
to avoid false positives (previously it was only scanning specific
sections and missing .ref.data).

----------------------------------------------------------------
Steven Rostedt (2):
      kmemleak: Scan all allocated, writeable and not executable module sections
      kmemleak: No need for scanning specific module sections

 kernel/module.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)
