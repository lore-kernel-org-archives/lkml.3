Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaKJMbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:31:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaKJMbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:31:04 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Tools: hv: vssdaemon: freeze/thaw logic improvement for the failure case
References: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C6105A0E13@HKNPRD3002MB017.064d.mgd.msft.net>
Date: Mon, 10 Nov 2014 13:30:54 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C6105A0E13@HKNPRD3002MB017.064d.mgd.msft.net>
	(Dexuan Cui's message of "Sat, 8 Nov 2014 01:07:47 +0000")
Message-ID: <87vbmnw83l.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: Saturday, November 8, 2014 1:09 AM
>> To: KY Srinivasan; Haiyang Zhang; Greg Kroah-Hartman
>> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Dexuan Cui
>> Subject: [PATCH 0/3] Tools: hv: vssdaemon: freeze/thaw logic improvement
>> for the failure case
>> 
>> This patch series addresses the following issues:
>> - Wrong error reporting for multiple filesystems case.
>> - Skip all readonly-mounted filesystems instead of skipping iso9660.
>> - Thaw all filesystems after an unsuccessful freeze attempt.
>> 
>> Vitaly Kuznetsov (3):
>>   Tools: hv: vssdaemon: consult with errno in case of failure only
>>   Tools: hv: vssdaemon: skip all filesystems mounted readonly
>>   Tools: hv: vssdaemon: thaw everything in case of freeze failure
>> 
>>  tools/hv/hv_vss_daemon.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> Hi Vitaly,
> Thanks for your patchset!
>
> FYI: Greg checked in a patch of mine several hours ago -- my patch
> implemented "thaw all filesytems on a failure of freeze" too. :-)

Ah, sorry for stepping on your toes :-)

>
> Please see my patch in Greg's char-misc-next tree:
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-next&id=4f689190bb55d171d2f6614f8a6cbd4b868e48bd
>
> Can you please rebase  your patch(es) on Greg's tree?

Sure, I'll throw away my patch#3, rebase, and repost.

>
> Thanks,
> -- Dexuan

-- 
  Vitaly
