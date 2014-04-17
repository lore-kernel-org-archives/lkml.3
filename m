Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaDQP3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:29:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55823 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaDQP3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:29:12 -0400
Message-ID: <534FF31E.1000104@zytor.com>
Date: Thu, 17 Apr 2014 08:28:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com> <534DFEDC.8090503@zytor.com> <534E0124.70700@oracle.com> <534E1559.8050904@hitachi.com> <534FF135.40404@oracle.com>
In-Reply-To: <534FF135.40404@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 08:20 AM, Sasha Levin wrote:
> 
> It's not like the instruction decoder is a generic piece of code right now anyways,
> it only serves mostly [k,u]probes and was built around the their requirements, and
> now everybody are surprised that kmemcheck has different requirements than kprobes.
> 

What *ARE* kmemcheck's requirements?  That's the real issue, I believe.

I also have seen several attempts at using the generic instruction
decoder which has resulted in more complexity, not less, because of
excess generality, so it is not an obvious thing.

	-hpa


