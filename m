Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaEOPb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:31:56 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:63862 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaEOPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:31:55 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
	<20140513163734.GA4602@amd.pavel.ucw.cz>
	<20140513214155.GA5087@amd.pavel.ucw.cz>
	<alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
	<20140514155759.GB9723@amd.pavel.ucw.cz>
	<20140514182046.GA13342@amd.pavel.ucw.cz>
	<alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
Date: Thu, 15 May 2014 17:31:54 +0200
Message-ID: <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
Subject: Re: 3.15-rc: regression in suspend
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 5:29 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> > Note that X do work somehow after resume (I can't switch virtual
>> > desktops and dialog is stuck on screen, but it is not complete
>> > failure). I can do ctrl-alt-f1 and get to useful prompt.
>>
>> Oops. You were right. It seems it is duplicate after all.
>>
>> [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 00001020 tail 00000000 start 00003000
>
> Pavel, thanks a lot for testing.
>
> Adding Daniel and Chris to CC -- we have another incarnation of the bug
> that is being chased in 76554.

Someone succeeding at a bisect would be awesome ... Note that the only
key here is the ring init failure in dmesg.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
