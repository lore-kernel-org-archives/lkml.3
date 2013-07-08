Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3GHSgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:36:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34294 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3GHSgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:36:24 -0400
Message-ID: <51DB069C.1010607@zytor.com>
Date: Mon, 08 Jul 2013 11:36:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EFI changes for v3.11
References: <20130626122331.GK22026@console-pimps.org> <20130703081903.GI25291@console-pimps.org> <3908561D78D1C84285E8C5FCA982C28F31C76880@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C76880@ORSMSX106.amr.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 10:29 AM, Luck, Tony wrote:
>>> ----------------------------------------------------------------
>>> Tony Luck (1):
>>>       [IA64] sim: Add casts to avoid assignment warnings
>>>
>>>  arch/ia64/hp/sim/boot/fw-emu.c | 20 ++++++++++----------
>>>  1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> I don't see this commit in Linus' tree so presumably Tony is still
>> seeing these warnings.
> 
> Correct - I see 10 warning about "assignment makes pointer from integer"
> when building Linus' tree (HEAD = d2b4a646).
> 
> My patch doesn't appear to be in linux-next either (next-20130708).
> 
> I had hoped to have this patch follow in the same path that the
> one that changed the types and introduced the warnings took ...
> but since that didn't work perhaps I should just ask Linus to pull
> it from my ia64 tree.
> 

I can push it, although it seems a bit odd to me to push an ia64-only
patch through the x86 tree.

Let me know what you prefer.

	-hpa


