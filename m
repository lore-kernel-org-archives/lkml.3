Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3CHGNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:13:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3CHGNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:13:14 -0500
Message-ID: <51398096.1060304@zytor.com>
Date: Thu, 07 Mar 2013 22:09:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jacob Shin <jacob.shin@amd.com>,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 01/14] x86, ACPI, mm: Kill max_low_pfn_mapped
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org> <1362718720-27048-2-git-send-email-yinghai@kernel.org> <20130308051059.GC14556@mtj.dyndns.org> <CAE9FiQVMjm7P28XLYGQ675we2+dU+H6rJK2eiO+FFeynYefJHA@mail.gmail.com> <CAOS58YOwSjHyFfAfaY_o3YZKhD-p2gc78ZGrc4N5_NCg+ZVu1A@mail.gmail.com> <CAE9FiQVFvg2M5A5Se5pys5yquNSZeOTV=s4YgLwr6QH_6=nY_w@mail.gmail.com> <CAOS58YNy_Rhg8M_7Qbgyutz68Q67i9R00rTuVy6CyZaFV1MSgA@mail.gmail.com>
In-Reply-To: <CAOS58YNy_Rhg8M_7Qbgyutz68Q67i9R00rTuVy6CyZaFV1MSgA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 09:28 PM, Tejun Heo wrote:
> On Thu, Mar 7, 2013 at 9:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> They are not using memblock_find_in_range(), so 1ULL<< will not help.
>>
>> Really hope i915 drm guys could clean that hacks.
> 
> The code isn't being used.  Just leave it alone.  Maybe add a comment.
>  The change is just making things more confusing.
> 

Indeed, but...

Daniel: can you guys clean this up or can we just remove the #if 0 clause?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

