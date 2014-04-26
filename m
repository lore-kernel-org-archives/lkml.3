Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaDZJXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:23:15 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61955 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDZJXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:23:10 -0400
Subject: Re: [PATCH] arm64: add OProfile support
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <535B707F.7020802@huawei.com>
Date: Sat, 26 Apr 2014 10:23:05 +0100
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <58ED971B-CC04-4BE1-916C-386D219874A8@arm.com>
References: <535B707F.7020802@huawei.com>
To: Ding Tianhong <dingtianhong@huawei.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 Apr 2014, at 09:38, Ding Tianhong <dingtianhong@huawei.com> wrote:
> Add OProfile support for arm64,  using the perf backend, and failing back
> to generic timer based sampling if PMU interrupt is not supported.
> 
> I have test this patch on Cortex-A53 and Cortex-A57 motherboard, the OProfile
> could work well by PMU irq or arch timer irq.

This came up before a few times and we also had an implementation but
decided not to merge it. We should rather get the user space oprofile to
use the perf kernel API.

That’s an old thread, it may have even made it into mainline oprofile
but I haven’t followed the development:

http://marc.info/?l=oprofile-list&m=133002515616302&w=2

Catalin