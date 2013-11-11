Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3KKHxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:53:46 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40202 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3KKHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:53:40 -0500
Message-ID: <52808CFC.6060701@linaro.org>
Date: Mon, 11 Nov 2013 16:53:32 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "patches@linaro.org" <patches@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>
Subject: Re: [PATCH RFC 4/6] arm64: Add kernel return probes support(kretprobes)
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org> <1382008671-4515-5-git-send-email-sandeepa.prabhu@linaro.org> <20131108170448.GF15074@mudshark.cambridge.arm.com> <CA+b37P2aeXs4Cy_HxF24HQAYAnYzZ19PgV6rqrQLY9SMpZHDJg@mail.gmail.com>
In-Reply-To: <CA+b37P2aeXs4Cy_HxF24HQAYAnYzZ19PgV6rqrQLY9SMpZHDJg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 01:29 PM, Sandeepa Prabhu wrote:
> On 8 November 2013 22:34, Will Deacon <will.deacon@arm.com> wrote:
>>> +static inline long regs_return_value(struct pt_regs *regs)
>>> +{
>>> +     return regs->regs[0];
>>> +}
>>
>> This is also being implemented by another patch series (I think the audit
>> stuff?).
> Not sure, I did not see this being implemented in audit(audit adds for
> 'syscallno',  not for return value in x0)
> I can rebase my code if this change is implemented and queued in other patchset.

Yes, my audit patch has it.
The definition is referred to in include/linux/audit.h (and ptrace.h),
too.

-Takahiro AKASHI
