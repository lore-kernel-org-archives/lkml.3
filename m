Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3EBKGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:06:32 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58778 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3EBKGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:06:31 -0400
MIME-Version: 1.0
In-Reply-To: <87sj27xxjr.fsf@rustcorp.com.au>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
 <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de> <87obcyc9sh.fsf@rustcorp.com.au>
 <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de> <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
 <C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de> <87sj27xxjr.fsf@rustcorp.com.au>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 2 May 2013 11:06:09 +0100
Message-ID: <CAFEAcA9h8iSYfTBtf6n+Vk5sDtBR2yB2oafRxikHoWbKt0VRUw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexander Graf <agraf@suse.de>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 May 2013 03:07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> An emergency output is a reasonable idea, and this is a reasonable
> implementation.  The question is practical: will it be used?  Because we
> don't implement reasonable ideas which aren't going to be used.

If you think it fits reasonably into the virtio spec (ie doesn't
implement things at the wrong level of the transport/backend
abstraction) then we can implement it in QEMU, and I think it
makes more sense to do this than to throw in a random extra
serial port.

To be actually useful we need to also specify something in
the device tree to say "here is where you will find your
emergency output and what it is".

thanks
-- PMM
