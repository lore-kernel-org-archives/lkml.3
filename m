Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaKXPtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:49:32 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:45079 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaKXPta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:49:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141124143819.GB20705@saruman>
References: <cover.1416547297.git.kiran.kumar@linaro.org> <7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
 <20141121151105.GC7508@saruman> <CA+RfmHZo4FuH6-Z8+VFY7Ao5QVD-VmfdCm17ZrB6f7J8Xpo-Aw@mail.gmail.com>
 <20141124143819.GB20705@saruman>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 24 Nov 2014 21:19:09 +0530
Message-ID: <CAO_48GFj2moODXtB1W9t6tbuvcyF2WgnakSDrbQRzPi+u=mc=g@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] usb: phy: Handle per-PHY event for connect and
 disconnect events
To: balbi@ti.com
Cc: Kiran Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 24 November 2014 at 20:08, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Nov 21, 2014 at 09:13:00PM +0530, Kiran Raparthy wrote:
>> On 21 November 2014 20:41, Felipe Balbi <balbi@ti.com> wrote:
>> > On Fri, Nov 21, 2014 at 11:31:21AM +0530, Kiran Raparthy wrote:
>> >> usb: phy: Handle per-PHY event for connnect and disconnect events
>> >>
>> >> When usb is connected and enumerated in device mode or when usb is
>> >> disconnected,call usb_phy_set_event from phy drivers to handle per-PHY event.
>> >>
>> >> Cc: Felipe Balbi <balbi@ti.com>
>> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >> Cc: linux-kernel@vger.kernel.org
>> >> Cc: linux-usb@vger.kernel.org
>> >> Cc: Android Kernel Team <kernel-team@android.com>
>> >> Cc: John Stultz <john.stultz@linaro.org>
>> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> >> Cc: Arve Hj�nnev�g <arve@android.com>
>> >> Cc: Benoit Goby <benoit@android.com>
>> >> [Original patch in Android from Todd]
>> >> Cc: Todd Poynor <toddpoynor@google.com>
>> >> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
>> >
>> > this patch doesn't apply, please rebase entire series on my testing/next.
>
> your rebased version didn't apply either. Can you make sure you're
> rebasing on top of my today's testing/next branch ?
>
I just verified that I am able to apply both this patch (and the next
one - so 2/3 and 3/3) on your testing/next branch - just to make sure,
this is the git/branch right?

https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
branch:testing/next

> cheers
>
> --
> balbi



-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
