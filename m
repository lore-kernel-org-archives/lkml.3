Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaLATJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:09:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57227 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbaLATJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:09:03 -0500
Message-ID: <547CBCC6.3060805@codeaurora.org>
Date: Mon, 01 Dec 2014 14:08:54 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jilai Wang <jilaiw@codeaurora.org>
CC: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robdclark@gmail.com
Subject: Re: [PATCH 2/4] drm/msm/hdmi: enable regulators before clocks to
 avoid warnings
References: <1417032984-11869-1-git-send-email-jilaiw@codeaurora.org>
In-Reply-To: <1417032984-11869-1-git-send-email-jilaiw@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jilai,

On 11/26/2014 03:16 PM, Jilai Wang wrote:
> HPD regulators need to be enabled before clocks, otherwise clock
> driver will report warning.
> 
> Change-Id: Ieca41722ae3b15873e6290649a21bbd13e1a4278

Nit: The upstream preference is to omit Change-Id lines. You should be able to
move .git/hooks/commit-msg to an alternate location and amend the patch to
remove it. Upstream checkpatch should warn about this--let me know if it's not
working properly.

Regards,
Chris

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
