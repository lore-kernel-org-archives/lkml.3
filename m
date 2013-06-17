Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3FQUbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:31:52 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:65203 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3FQUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:31:49 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130617202624.GA23915@codeaurora.org>
References: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
	<1371232615-30731-4-git-send-email-davidb@codeaurora.org>
	<20130615012617.GU18124@quad.lixom.net>
	<20130617202624.GA23915@codeaurora.org>
Date: Mon, 17 Jun 2013 13:31:49 -0700
Message-ID: <CAOesGMhthDb3rsm=GyAy=4F=mNYukYt70BpeS7fwBORkhAJ8sA@mail.gmail.com>
Subject: Re: [GIT PULL 2/3] msm fixes for 3.11
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 1:26 PM, David Brown <davidb@codeaurora.org> wrote:
> On Fri, Jun 14, 2013 at 06:26:17PM -0700, Olof Johansson wrote:
>
>>> Stephen Boyd (3):
>>>       ARM: dts: msm: Fix bad register addresses
>>
>>
>> Hmm. I see that the msm-hsuart device nodes completely lack reg entries.
>> That's
>> considerably more important to fix than the cosmetic unit address that's
>> not
>> even needed unless two nodes happen to have the same name.
>
>
> I'm not seeing the missing reg entries in anyone's tree.

Me neither. Hm. I wonder what I was looking at when I said that. Nevermind.

> However, it appears that both of us resolved the merge conflict
> differently, and both did it incorrectly.
>
> How would you like this to be fixed?  Should I just send you a patch
> based off of the current soc tree?

Yes, just send a patch, not a pull request.


-Olof
