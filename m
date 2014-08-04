Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaHDKlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:41:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaHDKj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:39:56 -0400
Message-Id: <20140804103025.478913141@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 12:30:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/7] nested sleeps, fixes and debug infra
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ilya recently tripped over a nested sleep which made Ingo suggest we should
have debug checks for that. So I did some, see patch 7. Of course that
triggered a whole bunch of fail the instant I tried to boot my machine.

With this series I can boot my test box and build a kernel on it, I'm fairly
sure that's far too limited a test to have found all, but its a start.

