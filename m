Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733Ab3LIKnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:43:41 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006Ab3LIKni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:43:38 -0500
Message-ID: <52A59ED9.4010608@free-electrons.com>
Date: Mon, 09 Dec 2013 11:43:37 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] clocksource: misc drivers: remove deprecated
 IRQF_DISABLED
References: <1381639028-6791-1-git-send-email-michael.opdenacker@free-electrons.com> <1386580330-4187-1-git-send-email-michael.opdenacker@free-electrons.com> <52A597C4.3050406@linaro.org>
In-Reply-To: <52A597C4.3050406@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 12/09/2013 11:13 AM, Daniel Lezcano wrote:
> On 12/09/2013 10:12 AM, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker
>> <michael.opdenacker@free-electrons.com>
>> ---
>
> Hi Michael,
>
> the three patches are applied to my tree for 3.14.
Great, thanks!

>
> I changed a bit the changelog by replacing 'proposes to remove' by
> 'removes' and added a capitalized letter for the first character of
> the short description (eg. remove deprecated => Remove deprecated).
>
> In the future please take care of that.

This makes perfect sense. I promise to pay attention to this in the future!

Thank you for the good advice!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

