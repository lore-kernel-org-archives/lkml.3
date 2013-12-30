Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3L3VRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:17:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40436 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3L3VRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:17:44 -0500
Message-ID: <52C1E2F6.6070600@codeaurora.org>
Date: Mon, 30 Dec 2013 13:17:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: arm@kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v2 0/7] Allow MSM DT platforms to be built multi-platform
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/13 13:15, Stephen Boyd wrote:
> These patches allow the DT based MSM platforms to be built as part of the
> multi-platform kernel. I need acks from Chris Ball on the mmc patch and
> Rob/Dave on the drm patch. I dropped Arnd's ack on patch 6 because I've
> rebased that patch on top of the patchset David sent out (which this is in
> reply to). 

Forgot to add --in-reply-to. This is on top of these patches:

Subject: [PATCH 0/7] MSM patches for 3.14
Date:	Fri, 20 Dec 2013 11:09:13 -0800
Message-Id: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

