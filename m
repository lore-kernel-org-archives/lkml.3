Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbaK1TVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 14:21:08 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47027 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaK1TVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 14:21:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141128181326.GA23784@lpalcu-laptop>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
	<1417180198-9393-1-git-send-email-laurentiu.palcu@intel.com>
	<20141128141053.GL7712@sirena.org.uk>
	<20141128145703.GA16201@lpalcu-linux>
	<20141128151435.GQ7712@sirena.org.uk>
	<20141128153125.GB16201@lpalcu-linux>
	<20141128160156.GX7712@sirena.org.uk>
	<20141128181326.GA23784@lpalcu-laptop>
Date: Fri, 28 Nov 2014 21:21:04 +0200
Message-ID: <CAE1zotKH7PfYyr1hLnMxOvbeOv-qC2XPzyh_ekHTqQyvy=w1LQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] spi: add support for DLN-2 USB-SPI adapter
From: Octavian Purdila <octavian.purdila@intel.com>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>,
        linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 8:13 PM, Laurentiu Palcu
<laurentiu.palcu@intel.com> wrote:
> On Fri, Nov 28, 2014 at 04:01:56PM +0000, Mark Brown wrote:
>> On Fri, Nov 28, 2014 at 05:31:25PM +0200, Laurentiu Palcu wrote:
>> > On Fri, Nov 28, 2014 at 03:14:35PM +0000, Mark Brown wrote:
>> > > On Fri, Nov 28, 2014 at 04:57:04PM +0200, Laurentiu Palcu wrote:
>>
>> > > > The other patch in this series was already applied by Lee on
>> > > > for-mfd-next branch:
>>
>> > > What this means is that the series you're sending actually contains one
>> > > patch, not two.  The point of numbering patches within a series is so
>> > > people can tell what order to apply them in, nothing else.  Things can
>> > > be lumped together and split during the upstreaming process, the only
>> > > thing that matterrs is what you're sending at a given time.
>>
>> > The order of the patches in this series can be interchanged. However, if
>> > you wish, I can resend the entire series again.
>>
>> No, please don't - you're missing the point.  The point is that now Lee
>> has applied the other patch you're not sending two patches any more,
>> you're sending a single patch.  This isn't patch 1/2, it's just a single
>> patch by itself now.
> I have to admit Linux kernel mailing list workflow is a little new to
> me...
>
> All I did was send new revisions of the 1/2 patch using the
> --in-reply-to option of git-send-email, with the message-id of the
> original version. I used to do this for other projects I contributed to,
> so I didn't have to re-send the entire series for just one patch that
> needs to be changed. Mail clients, at least the ones I use (mutt,
> evolution), order the mails nicely and you have all the history in one
> thread. So, one can see the cover letter of the series and the other
> original patches in the series, together with the new revisions of the
> changed patch. Of course, if more patches needed change, I would re-send a new
> series.
>
> So, Mark, can you please instruct me (a link to a page explaining the
> workflow would be fine too) what is the exact workflow you are/were
> expecting?
>

Mark was expecting to see [PATCH v7] instead of [PATCH v7 1/2] since
patch 2/2 of the series was already applied.
