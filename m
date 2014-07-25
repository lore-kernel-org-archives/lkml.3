Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbaGYLfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:35:15 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:60391 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGYLfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:35:11 -0400
MIME-Version: 1.0
In-Reply-To: <53BFB84A.900@samsung.com>
References: <1405069190-13986-1-git-send-email-sachin.kamat@samsung.com>
	<CAK5sBcFXo3YVeJ7U94f9_UuAuzCwmeOdCCJTE8D8pZEZfaOZbg@mail.gmail.com>
	<53BFB84A.900@samsung.com>
Date: Fri, 25 Jul 2014 17:05:09 +0530
Message-ID: <CAK5sBcECDcE-rH19tfcSv=Rd_v94rGmQP6iLh5Du3fFnzGkFTQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: Update Samsung pin control entry
From: Sachin Kamat <spk.linux@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 3:41 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> On 11.07.2014 11:57, Sachin Kamat wrote:
>> + Tomasz
>>
>> Sorry for missing the maintainer himself :)
>>
>> On Fri, Jul 11, 2014 at 2:29 PM, Sachin Kamat <sachin.kamat@samsung.com> wrote:
>>> Update to reflect the recent file movement to a sub-directory.
>>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
>>> ---
>>>  MAINTAINERS |    4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index e3a517635eb4..898cf76f8837 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -6943,9 +6943,7 @@ M:        Thomas Abraham <thomas.abraham@linaro.org>
>>>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>>  L:     linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
>>>  S:     Maintained
>>> -F:     drivers/pinctrl/pinctrl-exynos.*
>>> -F:     drivers/pinctrl/pinctrl-s3c*
>>> -F:     drivers/pinctrl/pinctrl-samsung.*
>>> +F:     drivers/pinctrl/samsung/
>>>
>>>  PIN CONTROLLER - ST SPEAR
>>>  M:     Viresh Kumar <viresh.linux@gmail.com>
>>> --
>>> 1.7.9.5
>>>
>>
>
> Acked-by: Tomasz Figa <t.figa@samsung.com>

Linus,
Gentle ping :)


-- 
Regards,
Sachin.
