Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3LELJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:09:50 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4629 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3LELJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:09:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Dec 2013 03:03:06 -0800
Message-ID: <52A05E55.3020605@nvidia.com>
Date: Thu, 5 Dec 2013 16:37:01 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [REPOST PATCH V2] irq: enable all irqs unconditionally in irq_resume
References: <1385388587-16442-1-git-send-email-ldewangan@nvidia.com> <52A05A21.5070100@nvidia.com> <201312051201.59284.heiko@sntech.de>
In-Reply-To: <201312051201.59284.heiko@sntech.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 December 2013 04:31 PM, Heiko Stübner wrote:
> Hi Laxman,
>
> Am Donnerstag, 5. Dezember 2013, 11:49:05 schrieb Laxman Dewangan:
>> Can you please review this patch?
>> This patch is pending from long back for review.
> the patch already made it into the appropriate tree, as can be seen by tip-bot
> message and on [0].
>
>
> Heiko
>
> [0] http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=irq-urgent-for-linus&id=ac01810c9d2814238f08a227062e66a35a0e1ea2

Seems I lost the applied mail and that's why I assumed that it is not 
reviewed yet. My bad, Sorry for  noise.
I can see the change in linux-next also.

Thanks Thomas/Heiko for review.

Thanks,
Laxman



