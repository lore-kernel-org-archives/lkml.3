Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3KOJ4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:56:04 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36922 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3KOJz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:55:56 -0500
MIME-Version: 1.0
In-Reply-To: <20131115040944.GA28070@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <1384445622-12346-5-git-send-email-bergwolf@gmail.com> <20131115040944.GA28070@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Fri, 15 Nov 2013 17:55:34 +0800
Message-ID: <CA+a=Yy7npJ0ZPgDm9EF+goD3LSV80u98CsnOctLhmLakB8NCKQ@mail.gmail.com>
Subject: Re: [PATCH 04/40] staging/lustre/llite: Access to released file trigs
 a restore
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:09 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 15, 2013 at 12:13:06AM +0800, Peng Tao wrote:
>> From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
>>
>> When a client accesses data in a released file,
>> or truncate it, client must trig a restore request.
>> During this restore, the client must not glimpse and
>> must use size from MDT. To bring the "restore is running"
>> information on the client we add a new t_state bit field
>> to mdt_info which will be used to carry transient file state.
>> To memorise this information in the inode we add a new flag
>> LLIF_FILE_RESTORING.
>
> This patch also does other things not mentioned here (coding style
> cleanups), which isn't allowed in a single patch (only do one thing per
> patch, and never not document what you are doing...)
>
I ported the original patch with as least modification as possible.
Guess I need to split this one (and the alike) so that it follows
upstream patch rules.

> It also adds checkpatch warnings, which I will not accept in patches at
> all here.  People are spending a lot of time cleaning up the coding
> style issues, please NEVER add new ones, that just causes more work to
> be needed to be done, and for people to have to go back and reclean
> files they have already cleaned up.
>
sorry... I will be more careful about this.

> So, sorry, I have to stop here at this series.  I've applied the first 3
> to the opw-next branch of staging.git so they can live somewhere until
> 3.13-rc1 is out.
>
Thanks!

> I know you spent a lot of time making these 120 patches to send me, but
> that too is crazy.  You shouldn't wait that long to get feedback and
> send patches to me at all.  Please send them in smaller series, with
> less time between patch submissions.
>
> So, care to just send me 10 patches or so now, which I can review and
> accept if good, and we can sync up and continue from there?
>
OK. I will split the patchsets into smaller ones. Thanks for reviewing!

Thanks,
Tao
