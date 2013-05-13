Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3EMRhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:37:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59908 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3EMRhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:37:02 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363158000"; 
   d="scan'208";a="46833228"
Message-ID: <519124BB.9030709@codeaurora.org>
Date: Mon, 13 May 2013 13:36:59 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 2/3] Documentation: virtio: Add emergency write (emerg_wr)
 config register in virtio console.
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org> <1367842791-30285-3-git-send-email-pranavkumar@linaro.org> <8761yn382w.fsf@rustcorp.com.au> <CAAHg+Hi6BHqwOznnC9qxkc5pBWz7r5qpz9Nhh=EeNenhjhHohg@mail.gmail.com>
In-Reply-To: <CAAHg+Hi6BHqwOznnC9qxkc5pBWz7r5qpz9Nhh=EeNenhjhHohg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranavkumar,

On 05/13/2013 02:56 AM, Pranavkumar Sawargaonkar wrote:
> Hi Rusty,
> 
> On 13 May 2013 08:22, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
>>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>>> ---
>>>  Documentation/virtual/virtio-spec.txt |    8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> OK, I applied this to the lyx master, with three changes:
>> 1) Changed "filed" to "field".
>> 2) Added ", or even acknowledging the feature" after "without
>>    initializing virtio queues".
>> 3) Added an initial point to the Device Initialization section:
>>
>>    1. If the VIRTIO_CONSOLE_F_EMERG_WRITE feature is offered, the
>>    emerg_wr field of the configuration can be written at any time. Thus
>>    it should work for very early boot debugging output as well as
>>    catastophic OS failures (eg. virtio ring corruption).
> 
> Thanks for applying this patch.
> Have you also applied first patch ([PATCH V2 1/3] virtio: console: Add
> emergency writeonly register to config space)
> with this?  (https://lkml.org/lkml/2013/5/6/169)

You seem to have omitted copying virtualization@lists.linux-foundation.org,
the mailing list documented in the MAINTAINERS file as appropriate for changes
relating to the virtio console driver.

[...]

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
