Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3EQGAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 02:00:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3EQGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 02:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <871u96a3dx.fsf@rustcorp.com.au>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
	<1367842791-30285-2-git-send-email-pranavkumar@linaro.org>
	<20130516123746.GA4744@amit.redhat.com>
	<871u96a3dx.fsf@rustcorp.com.au>
Date: Fri, 17 May 2013 11:30:38 +0530
Message-ID: <CAAHg+HhrvF6XxogiAA-8fzuT6byiwFUkpvr__qwTgKTxXDNdJw@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] virtio: console: Add emergency writeonly register
 to config space
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amit Shah <amit.shah@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2013 05:22, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Amit Shah <amit.shah@redhat.com> writes:
>> On (Mon) 06 May 2013 [17:49:49], Pranavkumar Sawargaonkar wrote:
>>> This patch adds an emerg_wr register (writeonly) in config space
>>> of virtio console device which can be used for debugging.
>>>
>>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>
>> OK, this change by itself looks harmless.
>>
>> Acked-by: Amit Shah <amit.shah@redhat.com>
>>
>>               Amit
>
> Thanks.  This is queued for *next* merge window.
>

Thanks amit and rusty.

> Cheers,
> Rusty.

Regards,
Pranav
