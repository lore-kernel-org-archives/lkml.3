Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaACSvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:51:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45863 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaACSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:51:07 -0500
Message-ID: <52C70698.2030004@codeaurora.org>
Date: Fri, 03 Jan 2014 10:51:04 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: arm@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@redhat.com>, David Brown <davidb@codeaurora.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 0/7] Allow MSM DT platforms to be built multi-platform
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org> <201401021913.25920.arnd@arndb.de>
In-Reply-To: <201401021913.25920.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/14 10:13, Arnd Bergmann wrote:
> On Monday 30 December 2013, Stephen Boyd wrote:
>> These patches allow the DT based MSM platforms to be built as part of the
>> multi-platform kernel. I need acks from Chris Ball on the mmc patch and
>> Rob/Dave on the drm patch. I dropped Arnd's ack on patch 6 because I've
>> rebased that patch on top of the patchset David sent out (which this is in
>> reply to). The rebase was fairly minor and the new patch for drm/msm is
>> trivial. Please consider for v3.14.
> Just for the record, I'm definitely happy with the way this is turning out,
> don't see my question on the serial driver as a NAK. I assume we will apply
> the patches for 3.14, but I first want to have a better understanding on
> where we are with the stuff that is already queued up for 3.14.
>

It would be great if we could get these patches in for 3.14. Now that
Olof has applied the collection of patches that David sent, these
patches should apply cleanly on top of arm-soc.git qcom/soc. Can you
apply them directly to the arm-soc tree?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

