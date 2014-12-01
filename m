Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaLAQKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:10:03 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44665 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaLAQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:09:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141201160442.GG11943@ulmo.nvidia.com>
References: <530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<54748541.4000600@users.sourceforge.net>
	<20141201160442.GG11943@ulmo.nvidia.com>
Date: Mon, 1 Dec 2014 11:09:58 -0500
Message-ID: <CAF6AEGupvi4tm=MrrYybDSMnrps-8rEqjZwhzbSW+85eBsa63w@mail.gmail.com>
Subject: Re: [PATCH 1/1] GPU-DRM-MSM: Deletion of unnecessary checks before
 two function calls
From: Rob Clark <robdclark@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 11:04 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Nov 25, 2014 at 02:33:53PM +0100, SF Markus Elfring wrote:
>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Tue, 25 Nov 2014 14:30:28 +0100
>>
>> The functions framebuffer_release() and vunmap() perform also input
>> parameter validation. Thus the test around the call is not needed.
>>
>> This issue was detected by using the Coccinelle software.
>>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> ---
>>  drivers/gpu/drm/msm/msm_fbdev.c | 3 +--
>>  drivers/gpu/drm/msm/msm_gem.c   | 3 +--
>>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> This needs the same fix for the subject prefix that I mentioned for your
> other patch, otherwise:
>
> Reviewed-by: Thierry Reding <treding@nvidia.com>
>
> Perhaps a good idea would be to send all of these patches with the
> subject prefix fixed up as a second version and threaded in a series.
> That makes it easier for people to pick them up (assuming Dave will take
> them directly).
>

no worries, I'll fix up the subject lines when I apply..

BR,
-R

> Thierry
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
