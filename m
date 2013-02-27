Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3B0GDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:03:35 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:60798 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3B0GDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
References: <20130223074001.GA5199@www.outflux.net>
	<CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
Date: Tue, 26 Feb 2013 22:03:32 -0800
X-Google-Sender-Auth: cjr7jwcDU22DhNP4Bie5ZCUywdk
Message-ID: <CAGXu5jL06MLHYtPdBXG7McS=xM7E3yjXVOy0hegQSa6BbZvi9A@mail.gmail.com>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Dan Williams <djbw@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 5:27 PM, Dan Williams <djbw@fb.com> wrote:
> On Fri, Feb 22, 2013 at 11:40 PM, Kees Cook <keescook@chromium.org> wrote:
>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
>> while now and is almost always enabled by default. As agreed during the
>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Alasdair G Kergon <agk@redhat.com>
>> ---
>>  drivers/md/Kconfig |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 7cdf359..0cc3a3d 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -158,7 +158,6 @@ config MULTICORE_RAID456
>>         bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
>>         depends on MD_RAID456
>>         depends on SMP
>> -       depends on EXPERIMENTAL
>
> In this case MULTICORE_RAID456 and the related code should go as
> well... now that there are patches to supersede this implementation in
> md-next.

Hrm, well as long as EXPERIMENTAL goes away, I'm happy. :) I sent this
most recent patch series based on what was living in linux-next, so if
that's changing, that's fine.

-Kees

-- 
Kees Cook
Chrome OS Security
