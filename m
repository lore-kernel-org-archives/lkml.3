Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbaLJRiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:38:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757930AbaLJRh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:37:58 -0500
Date: Wed, 10 Dec 2014 11:37:53 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.19
Message-ID: <20141210173753.GA25075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.19

This set includes one feature, which allows locks that
have been orphaned to be reacquired.
Thanks,
Dave

David Teigland (1):
      dlm: adopt orphan locks

 fs/dlm/lock.c                     | 76 +++++++++++++++++++++++++++++++++++++--
 fs/dlm/lock.h                     |  3 ++
 fs/dlm/user.c                     | 13 +++++--
 include/uapi/linux/dlmconstants.h |  2 +-
 4 files changed, 89 insertions(+), 5 deletions(-)

