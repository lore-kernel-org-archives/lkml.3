Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903Ab3IGA6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:58:47 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55110 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3IGA6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:58:45 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz> <20130906202022.GA353@x4> <CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com> <CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT] HID for 3.12 merge window
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Fri, 06 Sep 2013 17:58:41 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Message-ID: <506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Fri, Sep 6, 2013 at 2:50 PM, David Herrmann <dh.herrmann@gmail.com>
>wrote:
>> Hi
>>
>> On Fri, Sep 6, 2013 at 10:20 PM, Markus Trippelsdorf
>>>
>>>  commit 61e00655e9cb82e034eb72b95a51072e718d14a7
>>>  Author: David Herrmann <dh.herrmann@gmail.com>
>>>  Date:   Mon Aug 26 19:14:46 2013 +0200
>>>
>>>      Input: introduce BTN/ABS bits for drums and guitars
>>>
>>> The commit above breaks my Logitech mouse. The mouse cursor just
>sits in
>>> the middle of the screen and doesn't react to movements. dmesg is
>>> normal, but Xorg.0.log says:
>>
>> Ok, the issue is the kernel assumes ABS_MAX to be a power-of-2 minus
>1
>> (used as mask). That wasn't really obvious to me. Attached is a patch
>> which should fix that. Could you apply it on top of linus/master and
>> give it a try?
>
>Gah. I just wasted too much time bisecting down my logitech wireless
>keyboard not working to within a few commits of this, and decided to
>just try your patch.
>
>And yes, it makes my keyboard work.
>
>Dmitry, should I just apply the patch, or should we revert and use
>other bits? Please, this needs to be resolved, I stopped merging when
>I noticed this problem..

The patch still had problems so I'd revert it and wii bits and try again later.


Thanks.

-- 
Dmitry
