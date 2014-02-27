Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaB0T4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:56:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41286 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaB0T4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:56:16 -0500
Message-ID: <530F985E.5030503@codeaurora.org>
Date: Thu, 27 Feb 2014 11:56:14 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: config: Add qcom_defconfig
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org> <1393467394-10907-2-git-send-email-sboyd@codeaurora.org> <20140227154654.GB7308@joshc.qualcomm.com>
In-Reply-To: <20140227154654.GB7308@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/14 07:46, Josh Cartwright wrote:
> On Wed, Feb 26, 2014 at 06:16:32PM -0800, Stephen Boyd wrote:
>> Add a defconfig for mach-qcom platforms. Although these platforms
>> are part of the multi-platform kernel, it's useful to have a
>> stripped down version of the defconfig that just selects the
>> Qualcomm based platforms and drivers.
> How minimal are we aiming here?  It might be nice to at least get
> DEVTMPFS/DEVTMPFS_MOUNT=y in here, as I think udev barfs without it.
>

Sure that's fine as others are doing the same. I'll send a v1.1.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

