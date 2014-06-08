Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaFHJuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 05:50:15 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53571 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaFHJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 05:50:13 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140607120153.GA4721@amd.pavel.ucw.cz>
References: <20140528172521.GA9945@milliways>
	<20140607120153.GA4721@amd.pavel.ucw.cz>
Date: Sun, 8 Jun 2014 11:50:12 +0200
Message-ID: <CAKMK7uGz1pyuh_1wuFVpKuos9VoW7jaLK2rgPYiA2EtvbnS=ZQ@mail.gmail.com>
Subject: Re: Resume from suspend broken in 3.15. (bisected)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2014 at 2:01 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>  I've only started full testing of 3.15 on one of my machines now
>> that -rc7 has been released (this one had two issues in the radeon
>> code, second was fixed in rc7).  Unfortunately, suspend to RAM
>> (pm-suspend), or rather the wake-up, is broken on this box [ my
>> other two boxes are fine in rc7 ].
>>
>> Bisection identified one of your commits -
>>
>> commit 25f397a429dfa43f22c278d0119a60a343aa568f
>
> Thanks a lot for your work. It seems this commit breaks i915, too.

Really, really unlikely since we don't use that code with i915 at all.
Or git bisect has simply gone completely bananas and always brings up
this commit.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
