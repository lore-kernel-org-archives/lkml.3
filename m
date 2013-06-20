Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935748Ab3FTDqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:46:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39657 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935668Ab3FTDqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:46:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130620032812.GA24385@kroah.com>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
	<CACVXFVMhVs7Wy1A=TfczYzHLFwyRPhEGW9Yo9hTERekaxSnpdQ@mail.gmail.com>
	<20130619143918.GC8413@kroah.com>
	<CACVXFVObBDwaounzZ7RyF=+QrQCBoEd0s-uLYFokksOzKgZSjA@mail.gmail.com>
	<20130619163628.GA28672@kroah.com>
	<CACVXFVNsbBunNzYecUG34sFjPqRuzMHRTBD2Siy9d4RhqPnr3A@mail.gmail.com>
	<20130620110610.7d245d88b70620fa271a29f7@canb.auug.org.au>
	<CACVXFVN-B7ZrqjoA_QNkWKjM0XdM-S08h-d6JuRjsYOX0YPt=A@mail.gmail.com>
	<20130620032812.GA24385@kroah.com>
Date: Thu, 20 Jun 2013 11:46:11 +0800
Message-ID: <CACVXFVNLP4Wks_Fh+rUi7jLdL+tsGVKbpgME6CGt+s0_jm75rg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
From: Ming Lei <ming.lei@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:28 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Jun 20, 2013 at 09:22:13AM +0800, Ming Lei wrote:
>> Hi Stephen,
>>
>> Thanks for your help.
>>
>> On Thu, Jun 20, 2013 at 9:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> >
>> > Try "git diff-tree --cc e4b00d75ee3ed3af9fac83970d21e27d1ad4aa8d"
>>
>> Greg, Stephen, so is sort of below generated patch what you expected?
>>
>> If yes, I will send it out to you.
>
> Thanks, that helped out a lot.  I've now merged this together, and
> pushed it out to my driver-core-next branch, can you verify that I got
> it all correct?

I just pull your driver-core-next branch, looks drivers/base/firmware_class.c
is fine now, thank you

Thanks,
--
Ming Lei
