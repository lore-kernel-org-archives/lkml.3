Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3HCWUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 18:20:37 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:33275 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3HCWUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 18:20:35 -0400
MIME-Version: 1.0
In-Reply-To: <2483450.yz2brWbP8X@vostro.rjw.lan>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
	<13505759.IqzsRNCUnN@vostro.rjw.lan>
	<CAMP44s1SobAmSwth+=-pHYN77u-yEumqMfes1w3Bj-8sLTpWng@mail.gmail.com>
	<2483450.yz2brWbP8X@vostro.rjw.lan>
Date: Sat, 3 Aug 2013 17:20:33 -0500
Message-ID: <CAMP44s3kacF57gsJzyL6-4JWfWpdfJbJYW-nWQ92Yn1VimnYug@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 4:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, August 03, 2013 03:24:16 PM Felipe Contreras wrote:
>> On Sat, Aug 3, 2013 at 6:34 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Saturday, August 03, 2013 04:14:04 PM Aaron Lu wrote:
>>
>> >> Yes, the patch is correct, but I still prefer my own version :-)
>> >> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
>> >>
>> >> In case you want to take mine and mine needs refresh, please let me know
>> >> and I can do the re-base, thanks.
>> >
>> > Well, I prefer simpler, unless there's a good reason to use more complicated.
>>
>> Note that these are not exclusionary; his patch can be applied on top
>> of mine. I don't think his patch is needed though.
>
> OK
>
> Do we still need to revert commit efaa14c if this patch is applied?

I guess not. At least in this machine changing the backlight works
correctly, whereas in v3.11-rc3 it was all weird, and v3.7-v3.10
didn't work at all. I cannot see how it would affect negatively other
machines.

That being said, the blacklisting is still needed, because 1. the
level is not preserved between boots, and 2. level 0 turns off the
screen, which I personally consider a regression.

At least it boots to level 100 instead of 0.

-- 
Felipe Contreras
