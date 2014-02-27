Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaB0Puk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:50:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53409 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaB0Pte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:34 -0500
Date: Thu, 27 Feb 2014 09:46:54 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: config: Add qcom_defconfig
Message-ID: <20140227154654.GB7308@joshc.qualcomm.com>
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
 <1393467394-10907-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393467394-10907-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:16:32PM -0800, Stephen Boyd wrote:
> Add a defconfig for mach-qcom platforms. Although these platforms
> are part of the multi-platform kernel, it's useful to have a
> stripped down version of the defconfig that just selects the
> Qualcomm based platforms and drivers.

How minimal are we aiming here?  It might be nice to at least get
DEVTMPFS/DEVTMPFS_MOUNT=y in here, as I think udev barfs without it.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
