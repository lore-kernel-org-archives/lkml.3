Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaCGSyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:54:47 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43280 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaCGSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:54:45 -0500
MIME-Version: 1.0
In-Reply-To: <531A127E.2040005@gmail.com>
References: <1392724128-22920-1-git-send-email-jcmvbkbc@gmail.com>
	<CAMo8BfJAOTHHmmiEpL7jZa4ySvyPYsHGYUY+myN68BeewjeWYg@mail.gmail.com>
	<531A127E.2040005@gmail.com>
Date: Fri, 7 Mar 2014 22:54:44 +0400
Message-ID: <CAMo8BfJEQCppy=KtP+C-HLLdrTsgGpd7dwy+vKNuQa6V9pyBSw@mail.gmail.com>
Subject: Re: [PATCH] xtensa: enable sorting extable at build time
From: Max Filippov <jcmvbkbc@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: David Daney <david.daney@cavium.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 10:39 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 03/07/2014 01:56 AM, Max Filippov wrote:
>>
>> On Tue, Feb 18, 2014 at 3:48 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
>>>
>>> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>>> ---
>>>   arch/xtensa/Kconfig   | 1 +
>>>   scripts/sortextable.c | 5 +++++
>>>   2 files changed, 6 insertions(+)
>>
>>
>> Ping?
>> David, is this OK for scripts/sortextable.c?
>
>
> If you wish, you can add Acked-by: me.

Thanks.

> But I am not the maintainer of the file, so you will have to get someone
> else to merge it.

I guess we can merge this patch through the xtensa tree unless there are
any objections.

--
Thanks.
-- Max
