Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3KET4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:56:32 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34815 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3KETzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:55:49 -0500
Message-ID: <52794D42.9060306@linaro.org>
Date: Tue, 05 Nov 2013 14:55:46 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Export write_opcode() as uprobe_write_opcode()
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-2-git-send-email-dave.long@linaro.org> <20131105160150.GA1539@redhat.com> <20131105181614.GA7614@redhat.com> <20131105190153.GA32422@redhat.com>
In-Reply-To: <20131105190153.GA32422@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 14:01, Oleg Nesterov wrote:
> On 11/05, Oleg Nesterov wrote:
>>
>> And I think we can merge this change separately to reduce the
>> number of non-arm changes in the next version.
>
> And if you think this can help, I can push another change right
> now, see below.
>
> This way v3 will only need a single change outside of arch/arm,
> arch_uprobe_ignore(), and this change should be trivial.
>
> Oleg.
>

Yes, I agree it could only help if you merge that now instead of waiting 
for my patchset.  I have built and tested your patch in place of mine 
(on ARM) and it looks good.

-dl

