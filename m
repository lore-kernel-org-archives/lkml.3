Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaJUMKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:10:10 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50480 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaJUMKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:10:09 -0400
Message-ID: <54464D18.5070807@hitachi.com>
Date: Tue, 21 Oct 2014 21:10:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 1/2] ftracetest: add kprobes on ftrace testcase
References: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com> <1413802323-5297-2-git-send-email-heiko.carstens@de.ibm.com> <54462581.4050505@hitachi.com> <20141021115928.GB4161@osiris>
In-Reply-To: <20141021115928.GB4161@osiris>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/21 20:59), Heiko Carstens wrote:
> On Tue, Oct 21, 2014 at 06:21:05PM +0900, Masami Hiramatsu wrote:
>> (2014/10/20 19:52), Heiko Carstens wrote:
>>> Add a kprobes on ftrace testcase. The testcase verifies that
>>> - enabling and disabling function tracing works on a function which
>>>   already contains a dynamic kprobe
>>> - adding and removing a dynamic kprobe works on a function which is
>>>   already enabled for function tracing
>>>
>>
>> Looks good to me.
>>
>>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Hi Masami,
> 
> thanks! How should these two patches go upstream?

Steven, could you pick this series to your tree?
I think it is better to manage ftracetest testcases in one tree.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


