Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaCQTx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:53:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38538 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCQTx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:53:26 -0400
Message-ID: <532752AF.2080602@oracle.com>
Date: Mon, 17 Mar 2014 15:53:19 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] improve_stack: make stack dump output useful again
References: <1394994799-2221-1-git-send-email-sasha.levin@oracle.com>	<CA+55aFx-4XM3qzbEf1kgSDsuUm22sWCYHVaqK2D+juvHY3WEeg@mail.gmail.com>	<53274D93.8030105@oracle.com> <CA+55aFzzDDNLc3NzDSJ1q3ctyVJK9FXyCUxzBwQeoUHR94BLnA@mail.gmail.com>
In-Reply-To: <CA+55aFzzDDNLc3NzDSJ1q3ctyVJK9FXyCUxzBwQeoUHR94BLnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 03:49 PM, Linus Torvalds wrote:
> On Mon, Mar 17, 2014 at 12:31 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> What about duplicate symbol names? Without the full hex address we lose
>> the ability to correctly translate from symbol name to file/line.
>
> Yeah, and we should strive to avoid that issue.
>
> The thing is, think about address randomization. We can pretty much
> assume that is going to be the standard behavior due to it being
> really cheap (just a trivial boot time cost), and helping some
> security issues.
>
> So we might have a few ambiguous cases, that's still better than the
> alternative.

Makes sense. I'll send a patch to rename a small number of "high profile" symbols
that appear often and are duplicated to the respective subsystem maintainers.


Thanks,
Sasha

