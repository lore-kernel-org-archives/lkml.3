Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3LBHdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:33:46 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33266 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LBHdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:33:43 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1385917025.7199.4.camel@x41.thuisdomein>
References: <1385843936.10971.5.camel@x41.thuisdomein>
	<CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
	<1385917025.7199.4.camel@x41.thuisdomein>
Date: Mon, 2 Dec 2013 08:33:42 +0100
Message-ID: <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
Subject: Re: [i915] WARNING: [...] drivers/gpu/drm/i915/intel_display.c:9948 intel_get_pipe_from_connector
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 1, 2013 at 5:57 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2013-12-01 at 10:58 +0100, Daniel Vetter wrote:
>> Should be fixed with
>>
>> commit 7c063c725987406d743cc7de7625ff224fab75de
>> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Date:   Tue Nov 26 09:13:41 2013 -0800
>>
>>     drm/i915: take mode config lock around crtc disable at suspend
>>
>> which is currently in drm-intel-fixes. I'll forward it early next week.
>
> Thanks!
>
> The WARNING is now gone during suspend and resume (having tested that
> thoroughly - ie, twice). But I still see it at boot. Is there a related
> fix for that WARNING during boot?

Hm, I've never seen it during boot. Can you please boot with
drm.debug=0xe and attach the dmesg with the WARN?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
