Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaFMOYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:24:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaFMOYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:24:21 -0400
Date: Fri, 13 Jun 2014 09:24:18 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.16
Message-ID: <20140613142418.GB2954@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.16

This set includes one small fix related to resending SCTP messages.
Thanks,
Dave

Lidong Zhong (1):
      dlm: keep listening connection alive with sctp mode

 fs/dlm/lowcomms.c | 5 +++++
 1 file changed, 5 insertions(+)

