Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3KIRwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:52:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab3KIRwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:52:30 -0500
Date: Sat, 9 Nov 2013 18:53:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] uprobes: typeof(arch_uprobe->insn) cleanups
Message-ID: <20131109175350.GA17412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ananth, could you please explicitly ack or nack 2/2 ? It is
really simple, but obviously I can't test it. And even if it
is correct it should be merged only if you like it, this is
the minor cleanup.

Oleg.

