Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3FNISg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:18:36 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50438 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3FNISc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:18:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130614070641.GB28134@laptop>
References: <1371025182-31386-1-git-send-email-sachin.kamat@linaro.org>
	<20130613104943.GD16677@laptop>
	<CAK9yfHxJGtC5i8SQ0TLCzvXQwgskxAX5rpFsbNAnQvkSWqW0VQ@mail.gmail.com>
	<20130614070641.GB28134@laptop>
Date: Fri, 14 Jun 2013 13:48:31 +0530
Message-ID: <CAK9yfHyw+uKCF34uHh-h7huS6AnDLbvnjk6=2qZT4ir3O+5UjQ@mail.gmail.com>
Subject: Re: [PATCH Resend 1/1] mfd: davinci_voicecodec: Convert to use devm_* APIs
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 June 2013 12:36, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 14 Jun 2013, Sachin Kamat wrote:
>
>> Hi Lee,
>>
>> On 13 June 2013 16:19, Lee Jones <lee.jones@linaro.org> wrote:
>> > On Wed, 12 Jun 2013, Sachin Kamat wrote:
>> >
>> >> devm_* APIs are device managed and make code simpler.
>> >>
>> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> >> Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
>> >> ---
>> >> CC'd Lee Jones
>> >
>> > Can you resubmit this based on -rc5 please?
>> >
>> > There have been some related changes since you wrote this patch.
>>
>> This patch is based on Samuel's mfd-next tree [1].
>> This patch is dependent on your patch "mfd: davinci_voicecodec:
>> Convert to managed resources for allocating memory"
>> which is applied in mfd-next.
>>
>> Please let me know which other tree you want me to rebase this patch
>> on considering the dependency.
>>
>> [1] http://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git
>
> I believe Sam's branch has been updated considerably since you wrote
> the patch. Would you mind rebasing it onto Sam's latest master branch
> please? Should be commit: d8c5d658f425bd25bbfb137f2617f59ed4fdee7d.

It applies cleanly on top of the commit:
d8c5d658f425bd25bbfb137f2617f59ed4fdee7d
("Merge tag 'am335x_tsc-adc' of git://breakpoint.cc/bigeasy/linux").

I am surprised that you are getting errors. Anyway resending once again.

-- 
With warm regards,
Sachin
