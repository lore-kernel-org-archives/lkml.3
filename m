Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3FZKvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:51:47 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50164 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:51:46 -0400
MIME-Version: 1.0
In-Reply-To: <51CAC0A7.7090708@monstr.eu>
References: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com>
	<CAK9yfHzVSt1XN7=OZOtF_n_3jbpXObqoiay_t6n3EauTjUUX+w@mail.gmail.com>
	<51CAC0A7.7090708@monstr.eu>
Date: Wed, 26 Jun 2013 16:21:45 +0530
Message-ID: <CAK9yfHxuHuf1BnzR36c8Ucw_xrVcMW--jE-Gpng6tPNd17sB2A@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] uio: Use of_match_ptr() macro in uio_pdrv_genirq.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: monstr@monstr.eu
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 15:51, Michal Simek <monstr@monstr.eu> wrote:
> On 06/26/2013 12:00 PM, Sachin Kamat wrote:
>> On 26 June 2013 15:22, Michal Simek <michal.simek@xilinx.com> wrote:
>>> This eliminates having an #ifdef returning NULL for the case
>>> when OF is disabled.
>>>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>
>> I have already submitted a similar patch for doing this:
>> https://lkml.org/lkml/2013/3/14/169
>
> Ok. I don't care about it.
> Greg: Can you please add any of this patch to your char-misc tree?
>
> For Sachin patch.
> Acked-by: Michal Simek <monstr@monstr.eu>

Thanks Michal. Since Hans wasn't active the patch has been pending
since some time.
The latest rebased version has been posted [1] for Greg to apply.

[1] https://lkml.org/lkml/2013/6/25/7

-- 
With warm regards,
Sachin
