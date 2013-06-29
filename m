Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3F2Tli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 15:41:38 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:65103 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3F2Tlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 15:41:36 -0400
MIME-Version: 1.0
X-Originating-IP: [212.49.88.96]
In-Reply-To: <CAHVUoiRk7a=wViqK=UAGqcgL=OJXEVO=6hC-xV+mHWANWvV91w@mail.gmail.com>
References: <CAHVUoiQ5LpvCLUpx6SeMHAaHZZO0BmcYE3HfJa8OB_hp6aXHgQ@mail.gmail.com>
 <A3397C8B8B789E45844E7EC5DEAD89D02E5001EF@sausexdag04.amd.com> <CAHVUoiRk7a=wViqK=UAGqcgL=OJXEVO=6hC-xV+mHWANWvV91w@mail.gmail.com>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Sat, 29 Jun 2013 22:41:15 +0300
Message-ID: <CAHVUoiREVfiL6asGLN-r7EMeR83d71bXfqhzbhWxNz7BFEUTNA@mail.gmail.com>
Subject: Re: [REGRESSION] Radeon (Evergreen) Crash with "pin failed" in Kernel 3.10-rc7
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 6:45 PM, Brian Gitonga Marete
<marete@toshnix.com> wrote:
> On Fri, Jun 28, 2013 at 3:55 PM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
>>
>> Can you bisect?
>>
>

Hello Alexander,

So, it turns out that it is not so easy to reproduce this issue. I
have been trying to reproduce it with the exact revision of 3.10-rc7
where I first encountered the problem but with no luck. This of course
has hampered my bisection since I cannot be sure which revisions to
mark good/bad. Do you have any suggestions in this regard?

I however have a UVD-related lockup that I can always reproduce on
3.10-rc7: Trying to use UVD with the command: "mplayer -vo vdpau -vc
ffh264vdpau test.mp4" _always_locks up the same system (same kernel,
same DRI stack) hard. I will report this in a separate email, though
nothing at all shows up in the logs for this latter problem due to the
hard lockup. Suggestions about how to help debug this are also
welcome.

Many thanks.

--
Brian Gitonga Marete
CEO/CTO Toshnix Systems
http://toshnix.com
