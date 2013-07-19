Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab3GSHY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:24:58 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43543 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783Ab3GSHY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:24:57 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51E71202.5060207@codeaurora.org>
References: <20130625200211.GA11625@codeaurora.org> <20130628000853.GB11547@quad.lixom.net> <20130708153528.GB830@codeaurora.org> <51E71202.5060207@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Remove ARM local timer API
From: Olof Johansson <olof@lixom.net>
Date: Fri, 19 Jul 2013 09:24:35 +0200
To: Stephen Boyd <sboyd@codeaurora.org>
CC: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, Barry Song <baohua.song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <40771222-cc0f-4826-b14f-8dcdb4abb673@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Stephen Boyd <sboyd@codeaurora.org> wrote:

>On 07/08/13 08:35, Stephen Boyd wrote:
>> On 06/27, Olof Johansson wrote:
>>> On Tue, Jun 25, 2013 at 01:02:12PM -0700, Stephen Boyd wrote:
>>>> Olof/Arnd,
>>>>
>>>> These patches remove the ARM local timer API. The ARM architected
>>>> timers have already moved away from this API so this series
>>>> migrates the rest of the users allowing us to remove the API
>>>> entirely. Thomas has been kind enough to take the first two
>>>> patches into timers/core in the tip tree (thanks Thomas!) so I've
>>>> merged that into v3.10-rc1 and then applied the rest of the
>>>> patches on top. Let me know if this is acceptable.
>>> We need guarantees from Thomas that the branch is stable and will
>never be
>>> rebased before it hit Linus tree, or we'll be in a world of pain for
>>> dependencies like these.
>>>
>>> Thomas, is this branch stable or do you anticipate a rebase?
>>>
>> This branch has merged into Linus' tree. Can this go through the
>> arm-soc tree now?
>>
>
>The merge window is over now. Can this be merged for 3.12?

Yes, I am still traveling and haven't done any merges for 3.12 yet. This is first in the queue, I should get to it over the weekend or early next week.


-Olof

