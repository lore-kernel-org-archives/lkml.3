Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaAURsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:48:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbaAURsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:48:11 -0500
Date: Tue, 21 Jan 2014 11:48:07 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.14
Message-ID: <20140121174807.GB9144@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.14

This set includes a single change to speed up
recovery times when using SCTP connections.
Thanks,
Dave

Dongmao Zhang (1):
      dlm: set zero linger time on sctp socket

 fs/dlm/lowcomms.c | 8 ++++++++
 1 file changed, 8 insertions(+)

