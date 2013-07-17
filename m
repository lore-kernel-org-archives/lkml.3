Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3GQVwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:52:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46402 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3GQVwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:52:04 -0400
Message-ID: <51E71202.5060207@codeaurora.org>
Date: Wed, 17 Jul 2013 14:52:02 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, Barry Song <baohua.song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Remove ARM local timer API
References: <20130625200211.GA11625@codeaurora.org> <20130628000853.GB11547@quad.lixom.net> <20130708153528.GB830@codeaurora.org>
In-Reply-To: <20130708153528.GB830@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/13 08:35, Stephen Boyd wrote:
> On 06/27, Olof Johansson wrote:
>> On Tue, Jun 25, 2013 at 01:02:12PM -0700, Stephen Boyd wrote:
>>> Olof/Arnd,
>>>
>>> These patches remove the ARM local timer API. The ARM architected
>>> timers have already moved away from this API so this series
>>> migrates the rest of the users allowing us to remove the API
>>> entirely. Thomas has been kind enough to take the first two
>>> patches into timers/core in the tip tree (thanks Thomas!) so I've
>>> merged that into v3.10-rc1 and then applied the rest of the
>>> patches on top. Let me know if this is acceptable.
>> We need guarantees from Thomas that the branch is stable and will never be
>> rebased before it hit Linus tree, or we'll be in a world of pain for
>> dependencies like these.
>>
>> Thomas, is this branch stable or do you anticipate a rebase?
>>
> This branch has merged into Linus' tree. Can this go through the
> arm-soc tree now?
>

The merge window is over now. Can this be merged for 3.12?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

