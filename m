Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaCGIFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:05:49 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:39501 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCGIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:05:47 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <8738iuznze.fsf@rustcorp.com.au>
References: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
	<87r46gywul.fsf@rustcorp.com.au>
	<20140306075835.GC17001@phenom.ffwll.local>
	<8738iuznze.fsf@rustcorp.com.au>
Date: Fri, 7 Mar 2014 09:05:46 +0100
X-Google-Sender-Auth: qMa0Vr_wo8FjDO1QRzuDvchBkJQ
Message-ID: <CAKMK7uGDGd11SrnB5ErGTSpDka9H3HkZzG+kHp3CfNtoWADMWQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Taint the kernel for unsafe module options
From: Daniel Vetter <daniel@ffwll.ch>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 4:28 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> If this is a good idea, you can write a macro module_param_unsafe_named
>>> which is a general wrapper.
>>
>> For this to work I need to somehow store the safe default value somewhere.
>> since with bools or strings there really isn't such a thing, even less
>> than with integers where my fairly abitrary -1 choice is already
>> restricting. But I don't have a good idea how to do that, since creating a
>> local static struct in the macro to store the default + the pointer to the
>> storage location feels a bit ugly.
>
> I was thinking that if use the parameter, they get marked unsafe.  If
> they use it to set it to the default, Don't Do That.

Makes sense. I'll try to come up with something more polished which
addresses your's and Andrew's comments somewhen next week. Presuming
the (here one week later than everywhere else) carnival doesn't
interfere too badly ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
