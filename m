Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3HTRXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:23:24 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54409 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751319Ab3HTRXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:23:23 -0400
Date: Tue, 20 Aug 2013 18:22:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] arm64 perf fixes for 3.11
Message-ID: <20130820172245.GA23603@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Late pull request for arm64 perf fixes (similar to the recent arm perf
patches). Thanks.


The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-stable

for you to fetch changes up to ee7538a008a45050c8f706d38b600f55953169f9:

  arm64: perf: fix event validation for software group leaders (2013-08-20 12:05:57 +0100)

----------------------------------------------------------------
Perf backend fixes for arm64 where the user can cause kernel panic
(discovered with Vince's fuzzing tool).

----------------------------------------------------------------
Will Deacon (2):
      arm64: perf: fix array out of bounds access in armpmu_map_hw_event()
      arm64: perf: fix event validation for software group leaders

 arch/arm64/kernel/perf_event.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
Catalin
