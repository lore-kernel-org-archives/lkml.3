Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3GYU7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:59:55 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53756 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3GYU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:59:52 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130725171951.GD25415@radagast>
References: <1374605750-29565-1-git-send-email-olof@lixom.net>
	<20130725161406.GD31835@radagast>
	<CAOesGMiupSqpqfyuJ_abr4UQj9Ot77aGJZTsCEY63v-XttgPgw@mail.gmail.com>
	<20130725171951.GD25415@radagast>
Date: Thu, 25 Jul 2013 13:59:51 -0700
Message-ID: <CAOesGMgn0H4pteeWQcBzcccHr+F9Cf=Y+wvKHr2gCMfBBieOWg@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
From: Olof Johansson <olof@lixom.net>
To: Felipe Balbi <balbi@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:19 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Jul 25, 2013 at 09:18:39AM -0700, Olof Johansson wrote:
>> That's what the code does today, and I wasn't trying to second-guess
>> their decisions on that. Chances are firmware, in some instances, have
>> left power on so continuing might do no harm.
>
> fair enough, then let's just decrease the error message level to debug
> or info.

Fair enough. info seems appropriate (or warn). Want me to respin, or
can you edit when you apply?

Thanks,

-Olof
