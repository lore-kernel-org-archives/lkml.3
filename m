Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461Ab3LIJbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:31:47 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34039 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754954Ab3LIJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:31:46 -0500
Message-ID: <52A58E00.9000202@free-electrons.com>
Date: Mon, 09 Dec 2013 10:31:44 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: minyard@acm.org
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: remove deprecated IRQF_DISABLED
References: <1381636790-5943-1-git-send-email-michael.opdenacker@free-electrons.com> <525AF849.7060701@acm.org>
In-Reply-To: <525AF849.7060701@acm.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corey,

On 10/13/2013 09:45 PM, Corey Minyard wrote:
> Thanks, it's in the queue.
>
> -corey
>
> On 10/12/2013 10:59 PM, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Did you miss the latest merge window? I'm just asking to understand the
process...

Thank you for your support.

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

