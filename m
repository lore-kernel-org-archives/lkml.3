Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbaEMIL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:11:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:26375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbaEMILy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="510763251"
Message-ID: <5371D3C5.7070804@intel.com>
Date: Tue, 13 May 2014 13:41:49 +0530
From: "Jindal, Sonika" <sonika.jindal@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: David Airlie <airlied@linux.ie>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Archit Taneja <archit@ti.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: Re: [PATCH 01/12] drm: Move DRM_ROTATE bits out of omapdrm into drm_crtc.h
References: <1399622493-31701-1-git-send-email-sonika.jindal@intel.com> <1399622493-31701-2-git-send-email-sonika.jindal@intel.com> <20140513074628.GE6754@ulmo>
In-Reply-To: <20140513074628.GE6754@ulmo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

This patch was sent out by mistake.
I am sorry for the confusion.
I am working on further patchset based on these patches.

Regards,
Sonika

On 5/13/2014 1:16 PM, Thierry Reding wrote:
> On Fri, May 09, 2014 at 01:31:22PM +0530, sonika.jindal@intel.com wrote:
>> From: Ville Syrjälä <ville.syrjala at linux.intel.com>
>>
>> The rotation property stuff should be standardized among all drivers.
>> Move the bits to drm_crtc.h from omap_drv.h.
>>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: Rob Clark <robdclark@gmail.com>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Archit Taneja <archit@ti.com>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> Reviewed-by: Sagar Kamble <sagar.a.kamble@intel.com>
>> Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
>
> This is missing your Signed-off-by line. Also the patch subject says
> 01/12, where are the other eleven patches?
>
> Thierry
>
