Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3I0TDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:03:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37060 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3I0TDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:03:18 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5245C004.7070907@gmail.com>
References: <52442A3C.3010407@gmail.com>
	<CAKMK7uFvP7zisHL4UFjRqBX8mxS4DtosF2AFnwZDSdMgnDf4Lw@mail.gmail.com>
	<5245C004.7070907@gmail.com>
Date: Fri, 27 Sep 2013 21:03:18 +0200
Message-ID: <CAKMK7uFZ35gruMYHB+LXEDVoAof7n-1oYGxWkky_tLe3ELLxWQ@mail.gmail.com>
Subject: Re: 3.12 regression: i915 warnings
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 7:27 PM, Woody Suwalski <terraluna977@gmail.com> wrote:
> Daniel Vetter wrote:
>>
>> On Thu, Sep 26, 2013 at 2:36 PM, Woody Suwalski <terraluna977@gmail.com>
>> wrote:
>>>
>>> Daniel, I have noticed these warnings on 3.12-rc1, did not go away on
>>> 3.12-rc2.
>>> I see it only on EeePC with i915,not on ThinkPad with Radeon.
>>> It is a 32-bit kernel with overlayfs and TuxOnIce patches, so not
>>> perfectly
>>> clean, however same config and patches on 3.11 do not show these issues.
>>> No,sorry, did not have time to investigate further or bisect.If you have
>>> a
>>> quick test in mind - I will try ;-)
>>
>>
>> a) Please always cc: relevant mailing lists, not just your maintainer.
>> b) Please retest with latest drm-intel-fixes from
>> http://cgit.freedesktop.org/~danvet/drm-intel/
>> c) If that doesn't help please boot with drm.debug=0xe, reproduce the
>> issue once and attach the complete dmesg. Please make sure that it
>> contains everything from boot-up to the WARN.
>>
>> Thanks, Daniel
>
> For now I can do the last - a complete dmesg with drm.debug attached...
> I have hoped that you were to reply "Yawn, an old issue..." 8-)

Here we go: Mode flag mismatch in the tv encoder, should be fixed with

http://cgit.freedesktop.org/~danvet/drm-intel/commit/?id=1062b81598bc00e2f6620e6f3788f8f8df2f01e7

Pull request is already out and patch is cc: stable, so should show up
in a kernel near you soon.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
