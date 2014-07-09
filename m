Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaGINAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:00:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38979 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755552AbaGINAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:00:46 -0400
Date: Wed, 9 Jul 2014 14:00:17 +0100
From: Will Deacon <will.deacon@arm.com>
To: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFCv2] arm64: eBPF JIT compiler
Message-ID: <20140709130017.GL9485@arm.com>
References: <1404803213-10653-1-git-send-email-zlim.lnx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404803213-10653-1-git-send-email-zlim.lnx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 08:06:53AM +0100, Zi Shen Lim wrote:
> * Per discussion with Will, I'll also look into consolidating
>   bpf_jit.h into arch/arm64/kernel/insn.{c,h}.

I'm happy to review this once you have something ready.

> FUTURE WORK:
> 
> 1. Implement remaining classes of eBPF instructions: ST|MEM, STX|XADD
>    which currently do not have corresponding test cases in test_bpf.

I can help out with atomics, if you need it. Are the memory barrier
semantics well-defined for eBPF?

Will
