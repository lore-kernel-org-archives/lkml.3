Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3KKVVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:21:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab3KKVVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:21:11 -0500
Date: Mon, 11 Nov 2013 16:21:05 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.13
Message-ID: <20131111212105.GB1973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.13

This set includes a single fix to resolve to a race that could cause
lockspace shutdown to incorrectly return -EBUSY.
Thanks,
Dave

Bart Van Assche (1):
      dlm: Avoid that dlm_release_lockspace() incorrectly returns -EBUSY

 fs/dlm/lockspace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

