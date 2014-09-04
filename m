Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaIDUID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:08:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36112 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaIDUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:08:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAHg_5go_TT7CQ6U3AhjG4TxRM0zG562mxa+uV4UbOYd_-A0T-w@mail.gmail.com>
References: <20140811200931.GA18865@redhat.com> <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
 <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
 <CAHg_5gq1XiZ1A08PtQ7Rof3rUXJ-pVYkXtmHqgFh6hB+++qPNg@mail.gmail.com>
 <20140822140009.GA8567@redhat.com> <20140901201429.GA1586@lerouge> <CAHg_5go_TT7CQ6U3AhjG4TxRM0zG562mxa+uV4UbOYd_-A0T-w@mail.gmail.com>
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 4 Sep 2014 22:07:37 +0200
Message-ID: <CAHg_5gr_tHeBsQfv1ydZRq9XgKipcrbijripqubE6c6j1S=jfg@mail.gmail.com>
Subject: Re: nohz fail (was: perf related boot hang.)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 8:23 PM, Catalin Iacob <iacobcatalin@gmail.com> wrote:
> On Mon, Sep 1, 2014 at 10:14 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> I'll send "nohz: Restore NMI safe local irq work for local nohz kick"
>> as a fix for 3.17 and the rest will have to wait for 3.18 as it's a complicated
>> fix for a long standing bug.
>
> I've been running with the full series since you sent it and haven't
> experienced the bug since. I'll try to test with just the 3.17 patch
> to also check that it's enough on its own.

I tested with just "nohz: Restore NMI safe local irq work for local
nohz kick" on top of 7505ceaf8635 (which is 3.17-rc3 plus the merge of
1 commit) and unfortunately it doesn't fix the issue. I got the same
panic after some minutes of building Firefox.
