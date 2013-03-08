Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3CHF24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:28:56 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:64128 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3CHF2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:28:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVFvg2M5A5Se5pys5yquNSZeOTV=s4YgLwr6QH_6=nY_w@mail.gmail.com>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-2-git-send-email-yinghai@kernel.org>
	<20130308051059.GC14556@mtj.dyndns.org>
	<CAE9FiQVMjm7P28XLYGQ675we2+dU+H6rJK2eiO+FFeynYefJHA@mail.gmail.com>
	<CAOS58YOwSjHyFfAfaY_o3YZKhD-p2gc78ZGrc4N5_NCg+ZVu1A@mail.gmail.com>
	<CAE9FiQVFvg2M5A5Se5pys5yquNSZeOTV=s4YgLwr6QH_6=nY_w@mail.gmail.com>
Date: Thu, 7 Mar 2013 21:28:54 -0800
X-Google-Sender-Auth: 50BfY4GXjxABGSNi1_pNipxyLmg
Message-ID: <CAOS58YNy_Rhg8M_7Qbgyutz68Q67i9R00rTuVy6CyZaFV1MSgA@mail.gmail.com>
Subject: Re: [PATCH 01/14] x86, ACPI, mm: Kill max_low_pfn_mapped
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jacob Shin <jacob.shin@amd.com>,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 9:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> They are not using memblock_find_in_range(), so 1ULL<< will not help.
>
> Really hope i915 drm guys could clean that hacks.

The code isn't being used.  Just leave it alone.  Maybe add a comment.
 The change is just making things more confusing.

-- 
tejun
