Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaLPGSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:18:47 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:41619 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbaLPGSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:18:46 -0500
Message-ID: <548FCEB4.6090109@vmware.com>
Date: Tue, 16 Dec 2014 07:18:28 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for 3.19-rc1
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie> <CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
In-Reply-To: <CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.246]
X-ClientProxiedBy: EX13-CAS-013.vmware.com (10.113.191.65) To
 EX13-MBX-024.vmware.com (10.113.191.44)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 01:35 AM, Linus Torvalds wrote:
> On Sun, Dec 14, 2014 at 11:17 PM, Dave Airlie <airlied@linux.ie> wrote:
>> i915:
>>         Initial Skylake (SKL) support
>>         gen3/4 reset work
>>         start of dri1/ums removal
>>         infoframe tracking
>>         fixes for lots of things.
> So I'm not sure how happy I am about this. It seems to work, but on
> the very first boot I get this:
>
>

So this is my fault.

I posted the patch and there was a discussion with Chris Wilson at Intel
on dri-devel following the post concluding that the intel user-space
driver was type-casting dumb buffers, and that that was legitimate since
it didn't take place in generic user-space, but in a driver that had
detailed knowledge of the driver.

So I should have explicitly have withdrawn the patch. I'm sorry about this.

Thanks,
Thomas




