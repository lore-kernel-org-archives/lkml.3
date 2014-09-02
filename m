Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaIBSXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:23:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60170 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaIBSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140901201429.GA1586@lerouge>
References: <20140811200931.GA18865@redhat.com> <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
 <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
 <CAHg_5gq1XiZ1A08PtQ7Rof3rUXJ-pVYkXtmHqgFh6hB+++qPNg@mail.gmail.com>
 <20140822140009.GA8567@redhat.com> <20140901201429.GA1586@lerouge>
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Tue, 2 Sep 2014 20:23:26 +0200
Message-ID: <CAHg_5go_TT7CQ6U3AhjG4TxRM0zG562mxa+uV4UbOYd_-A0T-w@mail.gmail.com>
Subject: Re: nohz fail (was: perf related boot hang.)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 10:14 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> I'll send "nohz: Restore NMI safe local irq work for local nohz kick"
> as a fix for 3.17 and the rest will have to wait for 3.18 as it's a complicated
> fix for a long standing bug.

I've been running with the full series since you sent it and haven't
experienced the bug since. I'll try to test with just the 3.17 patch
to also check that it's enough on its own.

> Can I apply your Tested-by from you both?

Sure.
