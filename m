Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3GAUO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:14:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab3GAUOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:14:14 -0400
Date: Mon, 1 Jul 2013 16:14:10 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.11
Message-ID: <20130701201216.GD31303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.11

This set includes a number of SCTP related fixes in the dlm,
and a few other minor fixes and changes.

Thanks,
Dave


Bart Van Assche (1):
      dlm: Avoid LVB truncation

David Teigland (1):
      dlm: log an error for unmanaged lockspaces

Mike Christie (6):
      dlm: clear correct init bit during sctp setup
      dlm: set sctp assoc id during setup
      dlm: clear correct bit during sctp init failure handling
      dlm: try other IPs when sctp init assoc fails
      dlm: retry failed SCTP sends
      dlm: disable nagle for SCTP

Wei Yongjun (1):
      dlm: remove duplicated include from lowcomms.c

Zhao Hongjiang (1):
      dlm: config: using strlcpy instead of strncpy


 fs/dlm/config.c    |   5 +-
 fs/dlm/lock.c      |   8 +--
 fs/dlm/lockspace.c |   9 ++-
 fs/dlm/lowcomms.c  | 177 ++++++++++++++++++++++++++++++++++++++++-------------
 4 files changed, 149 insertions(+), 50 deletions(-)
