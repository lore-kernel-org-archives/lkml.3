Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3EGPws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:52:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16978 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab3EGPwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:52:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="45030447"
Message-ID: <5189234D.3040208@codeaurora.org>
Date: Tue, 07 May 2013 11:52:45 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Maydell <peter.maydell@linaro.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Amit Shah <amit.shah@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de> <87obcyc9sh.fsf@rustcorp.com.au> <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de> <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com> <C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de> <87sj27xxjr.fsf@rustcorp.com.au> <CAFEAcA9h8iSYfTBtf6n+Vk5sDtBR2yB2oafRxikHoWbKt0VRUw@mail.gmail.com> <87ip2wr8tp.fsf@rustcorp.com.au> <CAFEAcA_=BTXVdkN0WmajxVSjbDrmxc5z65hCbxr=7TqJVsE9EA@mail.gmail.com> <87txmfo0rl.fsf@rustcorp.com.au> <CAFEAcA9jBSpN2p9ZaU+_gX41Ke3nvpSKVrWV8Rioy_ioadKCgg@mail.gmail.com>
In-Reply-To: <CAFEAcA9jBSpN2p9ZaU+_gX41Ke3nvpSKVrWV8Rioy_ioadKCgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 08:19 AM, Peter Maydell wrote:
> On 7 May 2013 05:46, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Peter Maydell <peter.maydell@linaro.org> writes:
>>> That all looks like sensible QEMU implementation possibilities
>>> but it seems to be a bit of a non-sequitur from "how do we
>>> tell the kernel to actually use this?"
>>
>> You enable the feature in the virtio console device, and a kernel
>> compiled with EARLY_PRINTK will use it?
> 
> Well, at the moment EARLY_PRINTK is hardcoded to
> "use some specific UART or equivalent selected at
> compile time". So the equivalent presumably would
> be to hard-compile "use virtio-console", but then
> how does that code know where the virtio-console
> is in the address space?

arm64 uses a kernel argument.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
