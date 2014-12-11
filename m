Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaLKQnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:43:00 -0500
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49288 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbaLKQm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:42:58 -0500
Message-ID: <5489C98A.9030802@xs4all.nl>
Date: Thu, 11 Dec 2014 17:42:50 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
CC: linux-kernel@vger.kernel.org, Linux Media <linux-media@vger.kernel.org>,
        m.chehab@samsung.com, "hans.verkuil" <hans.verkuil@cisco.com>
Subject: Re: [PATCH] solo6x10: just pass frame motion flag from hardware,
 drop additional handling as complicated and unstable
References: <1415218274-28132-1-git-send-email-andrey.utkin@corp.bluecherry.net>	<5465E337.6020808@xs4all.nl> <CAM_ZknUu5xgp7gZoQJ_5XaX6CBRqYVxNJsZzsgBKGFcnUqKAJw@mail.gmail.com>
In-Reply-To: <CAM_ZknUu5xgp7gZoQJ_5XaX6CBRqYVxNJsZzsgBKGFcnUqKAJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 05:08 PM, Andrey Utkin wrote:
> On Fri, Nov 14, 2014 at 1:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Andrew,
>>
>> FYI: I need to test this myself and understand it better, so it will take some
>> time before I get to this. It is in my TODO list, so it won't be forgotten.
>>
>> Regards,
>>
>>         Hans
>>
>> On 11/05/2014 09:11 PM, Andrey Utkin wrote:
>>> Dropping code (introduced in 316d9e84a72069e04e483de0d5934c1d75f6a44c)
>>> which intends to make raising of motion events more "smooth"(?).
>>>
>>> It made motion event never appear in my installation.
>>> That code is complicated, so I couldn't figure out quickly how to fix
>>> it, so dropping it seems better to me.
>>>
>>> Another justification is that anyway application would implement
>>> "motion signal stabilization" if required, it is not necessarily kernel
>>> driver's job.
>>>
>>> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
>>> ---
>>>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 30 +-------------------------
>>>  drivers/media/pci/solo6x10/solo6x10.h          |  2 --
>>>  2 files changed, 1 insertion(+), 31 deletions(-)
>>>

<snip>

>>
> 
> Hi Hans, how is it proceeding with the subject of this patch?

Still haven't had the time to check this, other than a very quick test run.
Don't worry, it's in my TODO list, so I can't forget, but it has been busier
than usual lately. And this is one patch I really like to test before
committing.

Fingers crossed that I might be able to do it either tomorrow or on Monday.
If that fails, then the next opportunity will be after Christmas as I won't
have access to the hardware for awhile.

Regards,

	Hans
