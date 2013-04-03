Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297Ab3DCTSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:18:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763205Ab3DCTSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:18:12 -0400
Message-ID: <515C806D.7040100@canonical.com>
Date: Wed, 03 Apr 2013 15:18:05 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.8 Regression] Merge tag 'v3.7-rc2' into drm-intel-next-queued
References: <515C7E20.5060402@canonical.com> <CAKMK7uFRBXJZQo8k5AgiT-xAtk_g_P1zhuWSic35gdWmrcVQ=A@mail.gmail.com>
In-Reply-To: <CAKMK7uFRBXJZQo8k5AgiT-xAtk_g_P1zhuWSic35gdWmrcVQ=A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 03:16 PM, Daniel Vetter wrote:
> On Wed, Apr 3, 2013 at 9:08 PM, Joseph Salisbury 
> <joseph.salisbury@canonical.com 
> <mailto:joseph.salisbury@canonical.com>> wrote:
>
>     Hi Daniel,
>
>     A bug was opened against the Ubuntu kernel[0].  After a kernel
>     bisect, it was found the following was the first bad commit:
>
>
>     commit c2fb7916927e989ea424e61ce5fe617e54878827
>     Merge: 29de6ce 6f0c058
>     Author: Daniel Vetter <daniel.vetter@ffwll.ch
>     <mailto:daniel.vetter@ffwll.ch>>
>     Date:   Mon Oct 22 14:34:51 2012 +0200
>
>         Merge tag 'v3.7-rc2' into drm-intel-next-queued
>
>
>
>     The regression was introduced as of v3.8-rc1.  However, further
>     testing also shows this bug is now fixed in v3.9-rc4.
>
>     I see that you are the author of this patch, so I wanted see if I
>     can get your feedback.  Do you happen to have an idea what may
>     have fixed this in v3.9-rc4, so we can send a request to stable,
>     if not already done?  Otherwise, I can perform a reverse bisect to
>     see which commit fixed this.
>
>
> So apparently it's an oops somewhere in the nouveau setup code, which 
> bisected to a backmerge which has _only_ conflicts in drm/i915 driver 
> code.
>
> I have no idea what blew up here, sorry.
> -Daniel

Thanks for the info, Daniel.  I'll go the reverse bisect route.

>
>
>
>
>     Thanks,
>
>     Joe
>
>     [0] http://pad.lv/1109309
>
>
>
>
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

