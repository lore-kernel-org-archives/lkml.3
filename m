Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3FRFCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:02:34 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:64823 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3FRFCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130617173738.GA14921@kroah.com>
References: <20130412184335.GA5510@amd.pavel.ucw.cz>
	<20130617134741.GA15547@amd.pavel.ucw.cz>
	<20130617173738.GA14921@kroah.com>
Date: Tue, 18 Jun 2013 10:32:33 +0530
Message-ID: <CAK9yfHxMpzPuDP4D8EztaUxseuZCX7VEHFB7dBWtntDDjZJD6g@mail.gmail.com>
Subject: Re: [PATCH] Allow binding drivers/uio/uio_pdrv_genirq.c to devices
 using command line option
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@denx.de>, dzu@denx.de, hjk@hansjkoch.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 17 June 2013 23:07, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 17, 2013 at 03:47:41PM +0200, Pavel Machek wrote:
>> Hi!
>>
>> > This adds ability to bind uio driver to given open firmware device
>> > using command line option. Thus, userspace driver can be developed and
>> > used without modifying the kernel.
>> >
>> > Signed-off-by: Pavel Machek <pavel@denx.de>
>>
>> Ping? Greg, could you apply this patch? Or is there someone else I
>> should ask to apply it?
>
> Ugh, Hans seems to have dropped off of the net for a long time now, so I
> guess I'll start queueing up UIO patches again.  Care to resend this?
>

Even I have a couple of outstanding UIO patches [1-2]. Shall I resend
them as well?

[1] https://lkml.org/lkml/2013/3/14/154
[2] https://patchwork.kernel.org/patch/2268921/


-- 
With warm regards,
Sachin
