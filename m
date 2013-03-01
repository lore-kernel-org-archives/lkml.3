Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab3CAWsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 17:48:19 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49422 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3CAWsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 17:48:18 -0500
MIME-Version: 1.0
In-Reply-To: <CACSP8Sg=sTbJ_Yv=PdxvHQ--0_rTLN6XG3+0aFKzzHxMzVxKhw@mail.gmail.com>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
 <1362098606-26469-11-git-send-email-john.stultz@linaro.org>
 <20130301020008.GB13367@kroah.com> <51302792.6040408@linaro.org> <CACSP8Sg=sTbJ_Yv=PdxvHQ--0_rTLN6XG3+0aFKzzHxMzVxKhw@mail.gmail.com>
From: Erik Gilling <konkers@android.com>
Date: Fri, 1 Mar 2013 14:47:56 -0800
X-Google-Sender-Auth: gnFRzRWN5Hdd-oxwQgNlWyD8yck
Message-ID: <CACSP8SgHCJCZ2S+3NcUXEKg7fdV_LGZ7ZGXhYoMP0yPNc4c5Cg@mail.gmail.com>
Subject: Re: [PATCH 10/30] staging: sync: Export sync API symbols
To: John Stultz <john.stultz@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, lkml <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 12:21 AM, Erik Gilling <konkers@android.com> wrote:
> On Thu, Feb 28, 2013 at 7:59 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Given its the sync driver, its most obvious choice, but I agree its likely
>> to collide with filesystem related or other sync_ named functions that don't
>> have a subsystem prefix.
>>
>> Any suggestions?
>>
>> The only good alternative I can think of is that in some private
>> conversations with DanielV, he referred to Android using "sync-points".
>>
>> Erik: Would syncpoint_ be an ok prefix? Or do you have other ideas?
>
> syncpoint would be semantically weird when you end up with struct
> syncpoint_pt.  I'm open to suggestions as long as it works with
> XXXX_pt, XXXX_timeline, and XXXX_fence.  I'll ask around the office
> and see if someone has a good idea.

Colin Cross pointed out that this is limited to sync_fence_*,
sync_pt_*, and sync_timeline_* and not sync_* so it's much less likely
to have naming collisions.

Cheers,
  Erik
