Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaFWPR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:17:28 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38567 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaFWPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140623092650.GE8847@lee--X1>
References: <1402953143-24681-1-git-send-email-dianders@chromium.org>
	<20140618092012.GF23945@lee--X1>
	<CAD=FV=UiA=bsvune6A=wq+zKFq1+pkem0gTa-utxmBB6tKYM=A@mail.gmail.com>
	<20140623092650.GE8847@lee--X1>
Date: Mon, 23 Jun 2014 08:17:25 -0700
X-Google-Sender-Auth: gB-uWWCjLeVlI-M2CGRKfhgXmJw
Message-ID: <CAD=FV=Xnmd6dPrE2_NZ+Sy7cRjvgqOuQK27OzpBVygY9fwG-pQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: cros_ec_spi: set wakeup capability
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Mon, Jun 23, 2014 at 2:26 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> Lee (-others),
>
> Re-CC'ing the list.
>
>> On Wed, Jun 18, 2014 at 2:20 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> From: Prathyush K <prathyush.k@samsung.com>
>> >>
>> >> Set the device as wakeup capable and register the wakeup source.
>> >>
>> >> Note: Though it makes more sense to have the SPI framework do this,
>> >> (either via device tree or by board_info)
>> >> this change is as per an existing mail chain:
>> >> https://lkml.org/lkml/2009/8/27/291
>> >>
>> >> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
>> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> >> ---
>> >> Note that I don't have suspend/resume actually working upstream, but I
>> >> see that /sys/bus/spi/drivers/cros-ec-spi/spi2.0/power/wakeup exists
>> >> with this patch and doesn't exist without it.
>> >
>> > Very well.  Applied, thanks.
>>
>> Thanks for applying!  ...did this go in some non-standard branch?  I
>> see another of my patches got committed to your "for-mfd-next" tree on
>> the 19th but I don't see this one...
>
> Patience Grasshopper.  When I say that it's applied, it means that I
> have done so locally only.  After I've collected a few local patches
> I'll usually then fix them all with with my SoB and push them out to
> the public MFD tree.
>
> BTW, it's always best to leave the ML in as CC, so others can see the
> answer to these types of questions.  It may save a few emails a year,
> but every little helps. :)

Thanks!  I know it's super hard to keep track of everything, so I
figure that it's part of my job as a submitter to help maintainers
keep track of my patches.  I've definitely had many-a-time where
someone has said "oops, I forgot about that" or where people were not
on the same page about what the next steps ought to be.  Sounds like I
should perhaps tone back and wait a bit longer before I ping about
things.

Note: if there's any way you can provide more info to submitters like
me then it would certainly be appreciated!  In this case I was trying
hard not to be a noob.  I checked your public git tree and saw patches
applied that were after the date you sent your last email and didn't
see this patch.  I definitely don't know your personal workflow, but
it's good to know that didn't mean the patch was lost.

A few things that would have kept me from sending an email:

* If your email had read: "Applied to low priority fixes" and the
other email had read "Applied to high priority fixes" then I would
have understood that there were two queues and wouldn't have been
concerned.

* If you are able to publish (by pushing) your WIP collection to
patches to git.kernel.org then I would be able to confirm myself that
the patch wasn't lost.  If your queue was named something like "WIP"
then I would also have a good idea that inclusion in that queue isn't
a guarantee that my patch would land in mainline and I would also be
able to guess that git hashes were probably not stable there.


...anyway, as I said I will try to follow up less often and only ping
if I see silence for > 2 weeks.

:)


-Doug
