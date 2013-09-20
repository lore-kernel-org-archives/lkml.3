Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3ITNJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:09:40 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60668 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3ITNJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <cddbd29cf4bcef172196eb4d9f8d0464@mail.ud03.udmedia.de>
References: <CAPM=9twv-bb3MtnWNTT5+i5HfHQS+cbJG16xsaoL-XV_Qpf9Cw@mail.gmail.com>
	<cddbd29cf4bcef172196eb4d9f8d0464@mail.ud03.udmedia.de>
Date: Fri, 20 Sep 2013 09:09:38 -0400
Message-ID: <CADnq5_PSgYSFVO7Q2==0UAWYp7pLdo9cX4rjXv=sTAhadXTxTA@mail.gmail.com>
Subject: Re: [git pull] drm radeon/nouveau/core fixes
From: Alex Deucher <alexdeucher@gmail.com>
To: =?ISO-8859-1?Q?Dieter_N=FCtzel?= <dieter@nuetzel-hh.de>
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 8:01 AM, Dieter Nützel <dieter@nuetzel-hh.de> wrote:
> Am 19.09.2013 04:07, schrieb Dave Airlie:
>
>> Hi Linus,
>>
>> mostly radeon fixes, with some nouveau bios parser, ttm fix and a fix
>> for AST driver.
>>
>> Dave.
>>
>> The following changes since commit
>> 01172772c7c973debf5b4881fcb9463891ea97ec:
>>
>>   drm/nouveau: fix oops on runtime suspend/resume (2013-09-10 12:38:53
>> +1000)
>>
>> are available in the git repository at:
>>
>>   git://people.freedesktop.org/~airlied/linux drm-fixes
>>
>> for you to fetch changes up to 928c2f0c006bf7f381f58af2b2786d2a858ae311:
>>
>>   drm/fb-helper: don't sleep for screen unblank when an oops is in
>> progress (2013-09-19 11:54:34 +1000)
>
>
> [-]
>
>
>> Christian König (3):
>>       drm/radeon: remove stale radeon_fence_retire tracepoint
>>       drm/radeon: add command submission tracepoint
>>       drm/radeon: avoid UVD corruptions on AGP cards
>
>
> Alex,
>
> I think your PCIE AGP (radeon.agpmode=-1) UVD fix is missing, here.
>

It didn't get into this pull.  I'll be in my next -fixes pull.

Alex

> Thanks for working UVD and dpm on mostly all asics!
>
> -Dieter
