Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab3B1S2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:28:44 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35513 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3B1S2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:28:42 -0500
Message-ID: <512FA1D4.10507@linaro.org>
Date: Thu, 28 Feb 2013 10:28:36 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFD] Proposal for merging Android sync driver in staging
References: <512EBD80.8070101@linaro.org> <20130228023207.GB4042@kroah.com>
In-Reply-To: <20130228023207.GB4042@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 06:32 PM, Greg KH wrote:
> On Wed, Feb 27, 2013 at 06:14:24PM -0800, John Stultz wrote:
>> I'd like to get a discussion going about submitting the Android sync
>> driver to staging.
>>
>> I know there is currently some very similar work going on with the
>> dmabuf-fences, and rather then both approaches being worked out
>> individually on their own, I suspect there could be better
>> collaboration around this effort.
>>
>> So my proposal is that we merge the Android sync driver into staging.
>>
>> In my mind, this has the following benefits:
>> 1) It allows other drivers that depend on the sync interface to also
>> be submitted to staging, rather then forcing those drivers to be
>> hidden away in various out of tree git repos, location unknown.
>>
>> 2) It would provide a baseline view to the upstream community of the
>> interface Android is using, providing  a real-world, active use case
>> of the functionality.
>>
>> Once the sync driver is in staging, if the dmabuf-fences work is
>> fully sufficient to replace the Android sync driver, we should be
>> able to whittle down the sync driver until its just a interface shim
>> (and at which point efforts can be made to convert Android userland
>> over to dmabuf-fences).
> Sounds like a good plan to me.
>
>> I've gone through the Android tree and reworked the sync driver to
>> live in staging, while still preserving the full patch
>> history/authorship. You can checkout the reworked patch queue here:
>>   http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/sync-staging
> I can't really look at a git tree at the moment, but will always be glad
> to review patches.  Feel free to send them on and we can look at them
> then :)

Ok, since I preserved the patch history, its currently 30 patches, and I 
didn't want to flood everyone's inboxes with patches (Greg: I know you'd 
never do such a thing! :) before making sure there weren't any 
objections to the idea in concept.

I'll send out the stack later today.

thanks
-john

