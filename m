Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaCHBfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:35:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33662 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbaCHBfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:35:40 -0500
Message-ID: <531A73EB.6060403@codeaurora.org>
Date: Fri, 07 Mar 2014 17:35:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: pageexec@freemail.hu
CC: khali@linux-fr.org, rostedt@goodmis.org,
        Behan Webster <behanw@converseincode.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] module: LLVMLinux: Remove unused function warning from
 __param_check macro
References: <1394219327-5591-1-git-send-email-behanw@converseincode.com>, <531A4E84.9996.3260AF06@pageexec.freemail.hu>, <531A69E0.3000407@converseincode.com> <531A719C.19855.32E9C505@pageexec.freemail.hu>
In-Reply-To: <531A719C.19855.32E9C505@pageexec.freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 17:25, PaX Team wrote:
> On 7 Mar 2014 at 16:52, Behan Webster wrote:
>
>> On 03/07/14 14:56, PaX Team wrote:
>>> why can't you have the attr on the definition itself:
>>>
>>> static inline __unused type *__check_##name(void) { return(p); }
>>>
>>>
>>>
>> "__unused" isn't defined anywhere I can find, except in:
>>
>> src/linux/drivers/net/ethernet/amd/declance.c:#define __unused 
>> __attribute__ ((unused))
> oh i forgot about that, you'd of course place this #define
> into the appropriate compiler*.h files so that other code
> can make use of it in the future as well ;).
>

It looks like it already exists, __always_unused.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

