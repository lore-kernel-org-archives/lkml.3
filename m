Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbbAHQ0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:26:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbbAHQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:26:01 -0500
Message-ID: <54AEAF92.10507@canonical.com>
Date: Thu, 08 Jan 2015 11:25:54 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm
 by default on BTC
References: <54ADB86B.10105@canonical.com> <A3397C8B8B789E45844E7EC5DEAD89D0635DD4D6@satlexdag06.amd.com>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D0635DD4D6@satlexdag06.amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 09:51 PM, Deucher, Alexander wrote:
>
>> -----Original Message-----
>> From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com]
>> Sent: Wednesday, January 07, 2015 5:51 PM
>> To: Deucher, Alexander
>> Cc: stable@vger.kernel.org; LKML; Koenig, Christian; David Airlie; dri-devel
>> Subject: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm by
>> default on BTC
>>
>> Hi Alexander,
>>
>> A kernel bug report was opened against Ubuntu [0].  After a kernel
>> bisect, it was found that reverting the following commit resolved this bug:
>>
>> commit c08abf11900e19b14dd3a0cc3d105bd74519cd18
>> Author: Alex Deucher <alexander.deucher@amd.com>
>> Date:   Mon Jul 14 12:01:40 2014 -0400
>>
>>     drm/radeon: re-enable dpm by default on BTC
>>
>> The regression was introduced as of v3.17-rc1 and still exists in
>> current mainline.  It has also made it's way into the stable releases.
>>
>> I was hoping to get your feedback, since you are the patch author.  Do
>> you think gathering any additional data will help diagnose this issue,
>> or would it be best to submit a revert request?
>>
> Does revering b2dccf24e77 help?  I'd hate to revert this patch because it disables power management for a whole family of chips.  If it doesn't help I'd prefer to just add a quirk to disable it for the specific problematic board.
Commit b2dccf24e77 was added to mainline as of v3.18-rc1 and was not
cc'd to stable.  We are also seeing this issue in the 3.13.y stable
kernel, which does not have commit b2dccf24e77 applied.  However, we can
test reverting it in mainline?

>
> Alex
>
>> Thanks,
>>
>> Joe
>>
>> [0] http://pad.lv/1386534

