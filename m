Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab3LIOFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:05:01 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34788 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3LIOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:04:59 -0500
Message-ID: <52A5CE08.1060208@acm.org>
Date: Mon, 09 Dec 2013 08:04:56 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: remove deprecated IRQF_DISABLED
References: <1381636790-5943-1-git-send-email-michael.opdenacker@free-electrons.com> <525AF849.7060701@acm.org> <52A58E00.9000202@free-electrons.com>
In-Reply-To: <52A58E00.9000202@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 03:31 AM, Michael Opdenacker wrote:
> Hi Corey,
>
> On 10/13/2013 09:45 PM, Corey Minyard wrote:
>> Thanks, it's in the queue.
>>
>> -corey
>>
>> On 10/12/2013 10:59 PM, Michael Opdenacker wrote:
>>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>>
>>> It's a NOOP since 2.6.35 and it will be removed one day.
>>>
>>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Did you miss the latest merge window? I'm just asking to understand the
> process...

Yes, I did.  I was working with someone on another problem, and this is
the only thing I have queued, so I missed it.  I'll try to get it next
window.

-corey

>
> Thank you for your support.
>
> Cheers,
>
> Michael.
>

