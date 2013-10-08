Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3JHIKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:10:07 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45597 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3JHIKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:10:00 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYr5auasYPCiDniVQZyH7vN+EVrfTMnwuoAZyibizxG0Q@mail.gmail.com>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-11-git-send-email-sachin.kamat@linaro.org>
	<CACRpkdYr5auasYPCiDniVQZyH7vN+EVrfTMnwuoAZyibizxG0Q@mail.gmail.com>
Date: Tue, 8 Oct 2013 13:40:00 +0530
Message-ID: <CAK9yfHxh8zEumdtrZQLSv3JxtmhxMHeecFsuFLSTpo1SkuCOFQ@mail.gmail.com>
Subject: Re: [PATCH 11/11] pinctrl: plgpio: Remove redundant of_match_ptr
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 October 2013 13:36, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Sep 28, 2013 at 2:08 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>
>> The data structure of_match_ptr() protects is always compiled in.
>> Hence of_match_ptr() is not needed.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>
> I have applied this as well, and after that I squashed all 11 commits into
> one.
>
> I think these 11 patches should have been one from the beginning
> but it's quicker for me to simply squash them than to ask you to
> resubmit a squashed patch.

Thanks for doing it. I wasn't sure if you preferred single one to
driver-wise split.
Squashing is simpler compared to splitting :)

-- 
With warm regards,
Sachin
