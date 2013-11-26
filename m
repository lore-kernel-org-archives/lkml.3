Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3KZDZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:25:49 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:59745 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3KZDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:25:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131126031408.GA3666@kroah.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
 <1385431510-18988-3-git-send-email-bergwolf@gmail.com> <20131126031408.GA3666@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 26 Nov 2013 11:25:24 +0800
Message-ID: <CA+a=Yy4KuGugnCGcofNbKsWV6DsCYt_GVMPyjo9nsyasm9cp7w@mail.gmail.com>
Subject: Re: [PATCH 02/16] staging/lustre/llog: MGC to use OSD API for backup logs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mikhail Pershin <mike.pershin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:14 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 26, 2013 at 10:04:56AM +0800, Peng Tao wrote:
>> From: Mikhail Pershin <mike.pershin@intel.com>
>>
>> MGC uses lvfs API to access local llogs blocking removal of old code
>>
>> - MGS is converted to use OSD API for local llogs
>> - llog_is_empty() and llog_backup() are introduced
>> - initial OSD start initialize run ctxt so llog can use it too
>> - shrink dcache after initial scrub in osd-ldiskfs to avoid holding
>>   data of unlinked objects until umount.
>
> It is not checkpatch clean :(
>
> Come on, it's not hard to do this yourself, why do you make me find
> these errors for you?  It does nothing but make me not want to look at
> lustre patches for a long time...

Strange. I did run checkpatch before sending the patchset out.

Just tried again. Still pass.

[X61@linux-lustre]$./scripts/checkpatch.pl
0002-staging-lustre-llog-MGC-to-use-OSD-API-for-backup-lo.patch total:
0 errors, 0 warnings, 883 lines checked

0002-staging-lustre-llog-MGC-to-use-OSD-API-for-backup-lo.patch has no
obvious style problems and is ready for submission.

What message did you see?

Thanks,
Tao
