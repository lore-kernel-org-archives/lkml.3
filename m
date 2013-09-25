Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3IYOP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:15:26 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:50202 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3IYOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130925120149.GH21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
	<1379889942-3135-11-git-send-email-roy.franz@linaro.org>
	<e69e8c38-b195-4797-8ae2-65d69ed9d7aa@email.android.com>
	<CAFECyb_8hqLFajMUfwctVee8e8UvErmu4jmbPguWaeMc-MZuNA@mail.gmail.com>
	<523F8A3C.7010209@zytor.com>
	<20130925120149.GH21381@console-pimps.org>
Date: Wed, 25 Sep 2013 07:15:23 -0700
Message-ID: <CAFECyb8putN0Gy2OzpWYcjGSHmA0_aXx42=ToppXBJcffpxS0w@mail.gmail.com>
Subject: Re: [PATCH 10/18] Do proper conversion from UTF-16 to UTF-8
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 5:01 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Sun, 22 Sep, at 05:24:28PM, H. Peter Anvin wrote:
>> On 09/22/2013 04:07 PM, Roy Franz wrote:
>> > On Sun, Sep 22, 2013 at 3:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> >> Sorry this version is broken and doesn't even compile due to remaining options_size references.
>> >
>> > I compiled and tested this series on both x86_64 (using OVMF) and on
>> > the ARM simulator.  I just doubled checked
>> > my kernel .config to verify this was not being omitted and I'm pretty
>> > sure this doesn't have any compilation problems.
>> > I did make a few changes to get the untested version you sent out to
>> > compile, but they all seemed to be straightforward typo type fixes.
>> > I'll gladly address any defects in this patch, but I don't see an
>> > compilation problems.
>> >
>>
>> Ah yes, I see now... you fixed up the compile problem but did so
>> incorrectly.
>
> Folks, I'm gonna drop this patch for now. Feel free to resend it once
> everyone's happy with it. There's plenty of time to get this patch
> applied, it just doesn't make sense to hold up the rest of the series.

I'll get an updated (and independent) version out in the next couple days that
addresses HPA's feedback.

Thanks,
Roy
>
> --
> Matt Fleming, Intel Open Source Technology Center
