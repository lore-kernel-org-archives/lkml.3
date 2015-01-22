Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbbAVVl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:41:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57041 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbbAVVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:41:23 -0500
Date: Thu, 22 Jan 2015 13:41:22 -0800
From: Ken Westfield <kwestfie@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <joshc@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.org>, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 0/8] qcom audio clock control drivers
Message-ID: <20150122214121.GA23451@kwestfie-linux.qualcomm.com>
Mail-Followup-To: Ken Westfield <kwestfie@codeaurora.org>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Mike Turquette <mturquette@linaro.org>,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Josh Cartwright <joshc@codeaurora.org>,
	Rajendra Nayak <rnayak@codeaurora.org>, devicetree@vger.kernel.org,
	Kumar Gala <galak@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 06:05:27PM -0800, Stephen Boyd wrote:
> This patchset adds support for the low power audio subsystem (LPASS)
> clock controller hardware. I split out the #define patch for IPQ so that
> it can go through the clock tree and the arm-soc tree in parallel
> if desired.

Verified all supported bit clock frequencies for audio playback work on
the ipq806x SOC with max98357a codec.

Tested-by: Kenneth Westfield <kwestfie@codeaurora.org>

-- 
Kenneth Westfield
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project
