Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbAMMXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:23:16 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39342 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbAMMXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:23:15 -0500
Message-ID: <54B50E2B.2020007@hitachi.com>
Date: Tue, 13 Jan 2015 21:23:07 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Wang Nan <wangnan0@huawei.com>
Subject: Re: What's the correct tree to route kprobes patches through?
References: <1421086886.18443.23.camel@linaro.org>
In-Reply-To: <1421086886.18443.23.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/13 3:21), Jon Medhurst (Tixy) wrote:
> Hi All
> 
> I'm wondering what the correct route is for getting kprobes patches into
> mainline Linux. In particular I'm interested in a patch from Masami
> Hiramatsu [1] which is a dependency for some ARM kprobes work we want to
> merge. If acceptable, we could submit that one though the ARM
> maintainer's tree with our other work.

I'm OK to merge that patch via ARM's tree. Fortunately, that patch is
just a minor change. So I think it works.

Usually only generic or x86-dependent kprobes patches are upstreamed via
tip tree, and arch-dependent part of kprobes patches should go through arch
specific tree.
Of course I can also provide a new git repo for kprobes on kernel.org. :)
(But still which repo I should send a pull request is a question...)

Thank you,

> 
> [1] http://marc.info/?l=linux-kernel&m=142045769001242&w=2
>     (kprobes: Pass the original kprobe for preparing optimized kprobe)




-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


