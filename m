Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3H0CJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 22:09:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54754 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3H0CJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 22:09:22 -0400
Message-ID: <521C0A51.2000908@codeaurora.org>
Date: Mon, 26 Aug 2013 19:09:21 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: ksummit-2013-discuss@lists.linuxfoundation.org,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ARM ATTEND] catching up on exploit mitigations
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com> <5209BB6F.2000208@codeaurora.org> <20130826195632.GG10783@sirena.org.uk>
In-Reply-To: <20130826195632.GG10783@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2013 12:56 PM, Mark Brown wrote:
> On Mon, Aug 12, 2013 at 09:51:59PM -0700, Laura Abbott wrote:
>> On 7/30/2013 12:05 PM, Kees Cook wrote:
>
>>> - RO and W^X kernel page table protections (similar to x86's
>>> DEBUG_RODATA and DEBUG_SET_MODULE_RONX; it's not clear to me how much
>>> LPAE and PXN is already handling this, if at all)
>
>> We've had support for RO/NX on our tree for a while. I'm interested
>> in attending the summit to share what we've done and to see how much
>> of it could be mainlined.
>
> Is that related to the code that Google have in their tree?

It's 'related' in that it covers some of the same use cases but the two 
were developed independently as far as I know.

Thanks,
Laura



-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
