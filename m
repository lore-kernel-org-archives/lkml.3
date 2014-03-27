Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaC0AME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:12:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55681 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaC0AMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <2140283.ClKsmfFTvU@amdc1032>
References: <CAGRSmLtifL=hFBP1AUHB_va6ZvNfqXo8Bu=6XciH--jOEYVJjQ@mail.gmail.com>
	<20140324141558.31c169cf@alan.etchedpixels.co.uk>
	<2140283.ClKsmfFTvU@amdc1032>
Date: Wed, 26 Mar 2014 17:11:59 -0700
Message-ID: <CAGRSmLvmQ6HPgzPMVvNVHrJBDVqiRd6JeVpfJQ5S0NQycMjkHw@mail.gmail.com>
Subject: Re: patch fix for intel sdd s3500 series on Sil3512 controller
From: "David F." <df7729@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes.  The drive was found fine on other controllers I tried it on.

On Mon, Mar 24, 2014 at 8:27 AM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> + linux-ide mailing list on Cc:
>
> On Monday, March 24, 2014 02:15:58 PM One Thousand Gnomes wrote:
>> On Sat, 22 Mar 2014 16:32:54 -0700
>> "David F." <df7729@gmail.com> wrote:
>>
>> > Hi,
>> >
>> > It appears if nIEN is set all polling type IO fails.   After an
>> > attempt, future non-polled communications also fails.  This patch
>> > allows it to work.  Not sure if any spin lock protection would be
>> > needed or the system already handles the device existence for the
>> > generated irq with polling enabled.  handler already ignored irq if
>> > queued command was polling type.
>>
>> Does it behave plugged into a different controller without the hacks ?
>>
>> Alan
>
