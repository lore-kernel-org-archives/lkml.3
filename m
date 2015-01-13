Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbbAMCNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:13:05 -0500
Received: from lists.s-osg.org ([54.187.51.154]:47932 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbbAMCND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:13:03 -0500
Message-ID: <54B47F2D.9020102@osg.samsung.com>
Date: Mon, 12 Jan 2015 19:13:01 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] media: au0828 change to not zero out fmt.pix.priv
References: <cover.1418918401.git.shuahkh@osg.samsung.com> <54b748fa5cb6883d6ce348c38328161409c1f1be.1418918402.git.shuahkh@osg.samsung.com> <54B3D319.2090506@xs4all.nl>
In-Reply-To: <54B3D319.2090506@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 06:58 AM, Hans Verkuil wrote:
> My first code review of the new year, so let's start with a simple one to avoid
> taxing my brain cells (that are still in vacation mode) too much...
> 
> On 12/18/2014 05:20 PM, Shuah Khan wrote:
>> There is no need to zero out fmt.pix.priv in vidioc_g_fmt_vid_cap()
>> vidioc_try_fmt_vid_cap(), and vidioc_s_fmt_vid_cap(). Remove it.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 

Thanks.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
