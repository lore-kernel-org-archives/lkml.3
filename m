Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3CGK2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:28:10 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:59970 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3CGK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:28:08 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303071108150.28677@pobox.suse.cz>
References: <20130306115052.2b1969acb7b7a0fa35975984@canb.auug.org.au>
	<51379849.6040903@infradead.org>
	<CAN+gG=H4_1nUhhsUe031Q1QrnVna+F7hmAepe6kbNm=8z_gOjw@mail.gmail.com>
	<alpine.LNX.2.00.1303071108150.28677@pobox.suse.cz>
Date: Thu, 7 Mar 2013 11:28:05 +0100
Message-ID: <CAN+gG=HhatpiPWUJ72Pr45odtcM6AJ5broNVrQ_=dF5AU6TEig@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 6 (hid)
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:09 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 7 Mar 2013, Benjamin Tissoires wrote:
>
>> > on i386 and x86_64:
>> >
>>
>> Sorry, it looks like my patches went not very smoothly.
>>
>> > ERROR: "usb_control_msg" [drivers/hid/hid-multitouch.ko] undefined!
>>
>> I've submitted a new patch removing this direct call. Maybe we should
>> change the Kconfig while these patches are not applied. Jiri?
>
> Benjamin,
>
> which patch is that? The only hid-multitouch I still have in my queue is
> the hybrid finger/pen devices support, and I don't think it's fixing this
> problem.

You should have at least one other patch for hid-mt:
https://patchwork.kernel.org/patch/2193641/

And I sent as a RFC the patch I was talking about:
https://patchwork.kernel.org/patch/2193801/
https://patchwork.kernel.org/patch/2193821/

These two RFCs have been reviewed by David Herrmann, so maybe we can
include them in their current form as no one else complained about it
( maybe you will :) ).

Cheers,
Benjamin

>
> Then I have one for logitech-dj which I still need to review, but I don't
> see anything else ... ?
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
