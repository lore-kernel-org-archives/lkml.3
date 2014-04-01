Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaDAUbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:31:36 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:58110 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbaDAUbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:31:35 -0400
Message-ID: <1396384291.23763.22.camel@x220>
Subject: Re: [GIT PULL] RCU changes for v3.15
From: Paul Bolle <pebolle@tiscali.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Apr 2014 22:31:31 +0200
In-Reply-To: <20140331081724.GA3193@gmail.com>
References: <20140331081724.GA3193@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2014 20:31:31.0522 (UTC) FILETIME=[5DE7BA20:01CF4DE9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Paul E. McKenney (70):
>      [...]
>       locktorture: Add a lock-torture kernel module

This commit added a check for CONFIG_LOCK_TORTURE_TEST_RUNNABLE. But I
can't find a Kconfig symbol LOCK_TORTURE_TEST_RUNNABLE nor a
preprocessor define for CONFIG_LOCK_TORTURE_TEST_RUNNABLE. (I only
checked master of Linus's tree and linux-next.)

Is this check for CONFIG_LOCK_TORTURE_TEST_RUNNABLE needed?


Paul Bolle

