Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3JMTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 15:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab3JMTZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 15:25:28 -0400
Date: Sun, 13 Oct 2013 21:18:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] uprobes: fix fork() with the pending ret-probe(s)
Message-ID: <20131013191815.GA32466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Please review, this series fixes the serious bug reported by
Martin and David and cc's stable. See the changelog in 5/5.

Oleg.

 kernel/events/uprobes.c |  144 +++++++++++++++++++++++++++++++++++------------
 kernel/fork.c           |    2 +-
 2 files changed, 109 insertions(+), 37 deletions(-)

