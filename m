Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbaLLJEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:04:49 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59193 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbaLLJEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:04:45 -0500
Message-ID: <548AAF9F.4000207@xs4all.nl>
Date: Fri, 12 Dec 2014 10:04:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, mkrufky@linuxtv.org,
        dheitmueller@kernellabs.com, prabhakar.csengg@gmail.com,
        ramakrmu@cisco.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: au0828 - convert to use videobuf2
References: <1418257692-8030-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1418257692-8030-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 01:28 AM, Shuah Khan wrote:
> Convert au0828 to use videobuf2. Tested with NTSC.
> Tested video and vbi devices with xawtv, tvtime,
> and vlc. Ran v4l2-compliance to ensure there are
> no new regressions in video and vbi now has 3 fewer
> failures.
> 
> video before:
> test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> test VIDIOC_G_FMT: FAIL 3 failures
> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
> 
> Video after:
> test VIDIOC_DBG_G/S_REGISTER: OK
> test VIDIOC_G_FMT: FAIL 3 failures
> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
> 
> vbi before:
> test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> test VIDIOC_EXPBUF: FAIL
> test USERPTR: FAIL
> Total: 72, Succeeded: 66, Failed: 6, Warnings: 0
> 
> vbi after:
> test VIDIOC_DBG_G/S_REGISTER: OK
> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> test VIDIOC_EXPBUF: OK (Not Supported)
> test USERPTR: OK
> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

FYI: since it is so hard to comment on vb2 conversion patches,
I'm going to comment on the vbi.c and video.c sources with your
patch applied. I'll do that in two separate posts.

Regards,

	Hans
