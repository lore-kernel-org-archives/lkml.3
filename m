Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaJWBE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:04:29 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55735 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaJWBE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:04:28 -0400
Message-ID: <54485414.6030608@hitachi.com>
Date: Thu, 23 Oct 2014 10:04:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftracetest: add kprobes on ftrace testcase
References: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com> <1413802323-5297-2-git-send-email-heiko.carstens@de.ibm.com> <54462581.4050505@hitachi.com> <20141021115928.GB4161@osiris> <54464D18.5070807@hitachi.com> <20141022110434.0c47eb0a@gandalf.local.home>
In-Reply-To: <20141022110434.0c47eb0a@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/23 0:04), Steven Rostedt wrote:
> On Tue, 21 Oct 2014 21:10:00 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>> Steven, could you pick this series to your tree?
>> I think it is better to manage ftracetest testcases in one tree.
> 
> I can pick these up. Is it OK if it goes into the 3.19 queue? Or is
> there some urgent need to get them into 3.18? As they are ftracetests,
> it's not that big of a deal to get them in early, as it is highly
> unlikely to break the kernel itself.

It seems we have no urgent need, I think 3.19 queue is OK. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


