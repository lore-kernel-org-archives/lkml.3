Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3EFJOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:14:47 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:41222 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3EFJOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <87ip2wr8tp.fsf@rustcorp.com.au>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
 <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de> <87obcyc9sh.fsf@rustcorp.com.au>
 <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de> <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
 <C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de> <87sj27xxjr.fsf@rustcorp.com.au>
 <CAFEAcA9h8iSYfTBtf6n+Vk5sDtBR2yB2oafRxikHoWbKt0VRUw@mail.gmail.com> <87ip2wr8tp.fsf@rustcorp.com.au>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 6 May 2013 10:14:23 +0100
Message-ID: <CAFEAcA_=BTXVdkN0WmajxVSjbDrmxc5z65hCbxr=7TqJVsE9EA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexander Graf <agraf@suse.de>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Amit Shah <amit.shah@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2013 06:11, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Peter Maydell <peter.maydell@linaro.org> writes:
>> To be actually useful we need to also specify something in
>> the device tree to say "here is where you will find your
>> emergency output and what it is".
>
> Hmm, I'm not sure that's true.  It looks like it needs:
>
> 1) An enhancment to the vdev->set_config callback to pass through (at
>    least) an offset, probably offset and length.
>
> 2) An emerg_write() function ptr which can be called at any time, set by
>    virtio_console.c's class_init:

That all looks like sensible QEMU implementation possibilities
but it seems to be a bit of a non-sequitur from "how do we
tell the kernel to actually use this?"

-- PMM
