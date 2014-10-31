Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaJaLVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:21:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaJaLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:44 -0400
Message-Id: <20141031111037.936236584@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/7] Various fixes for nested sleep stuff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a few patches fixing reported nested sleep warns and issues.


