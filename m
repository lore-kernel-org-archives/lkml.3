Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3KUXVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:21:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49954 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3KUXVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:21:02 -0500
Message-ID: <528E955C.7090205@codeaurora.org>
Date: Thu, 21 Nov 2013 15:21:00 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Olof Johansson <olof@lixom.net>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/17] Convert ARM sched_clock users to sched_clock_register()
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org> <87li0h8i70.fsf@linaro.org>
In-Reply-To: <87li0h8i70.fsf@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/13 15:10, Kevin Hilman wrote:
> Hi Stephen,
>
> Stephen Boyd <sboyd@codeaurora.org> writes:
>
>> Olof,
>>
>> Please consider picking up these simple conversion patches. They
>> were sent a few months back[1] but I didn't keep pushing them due
>> to the complex path to mainline that the core patches took. I've
>> picked up the acks and resent. Now that the core kernel changes have
>> landed in Linus' tree it's much easier to pull these changes in.
> Just to clarify, are the dependencies in v3.12? or were they merged for
> the v3.13 merge window and just recently it Linus' tree.

The dependencies are not in 3.12. They just hit Linus' tree this merge
window (3.13). Ingo brought it into tip at commit
68e90740284c69292881cd38c7ece6f09a18a58f and Linus took it at commit
87093826aa0172d9135ca1f301c4298a258ceee6.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

