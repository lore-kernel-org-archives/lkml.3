Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbbAGWvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:51:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57855 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbbAGWvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:51:35 -0500
Message-ID: <54ADB86B.10105@canonical.com>
Date: Wed, 07 Jan 2015 17:51:23 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: alexander.deucher@amd.com
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, christian.koenig@amd.com,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm by
 default on BTC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

A kernel bug report was opened against Ubuntu [0].  After a kernel
bisect, it was found that reverting the following commit resolved this bug:

commit c08abf11900e19b14dd3a0cc3d105bd74519cd18
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Mon Jul 14 12:01:40 2014 -0400

    drm/radeon: re-enable dpm by default on BTC

The regression was introduced as of v3.17-rc1 and still exists in
current mainline.  It has also made it's way into the stable releases.

I was hoping to get your feedback, since you are the patch author.  Do
you think gathering any additional data will help diagnose this issue,
or would it be best to submit a revert request?
    
    
Thanks,

Joe

[0] http://pad.lv/1386534

