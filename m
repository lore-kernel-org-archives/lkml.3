Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbbA0Tw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:52:28 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61034 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773AbbA0TwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:52:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ken Westfield <kwestfie@codeaurora.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20150122214121.GA23451@kwestfie-linux.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Josh Cartwright" <joshc@codeaurora.org>,
        "Rajendra Nayak" <rnayak@codeaurora.org>, devicetree@vger.kernel.org,
        "Kumar Gala" <galak@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
 <20150122214121.GA23451@kwestfie-linux.qualcomm.com>
Message-ID: <20150127195206.22722.54678@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 0/8] qcom audio clock control drivers
Date: Tue, 27 Jan 2015 11:52:06 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ken Westfield (2015-01-22 13:41:22)
> On Mon, Jan 19, 2015 at 06:05:27PM -0800, Stephen Boyd wrote:
> > This patchset adds support for the low power audio subsystem (LPASS)
> > clock controller hardware. I split out the #define patch for IPQ so that
> > it can go through the clock tree and the arm-soc tree in parallel
> > if desired.
> 
> Verified all supported bit clock frequencies for audio playback work on
> the ipq806x SOC with max98357a codec.
> 
> Tested-by: Kenneth Westfield <kwestfie@codeaurora.org>

Applied to clk-next.

Regards,
Mike

> 
> -- 
> Kenneth Westfield
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
> a Linux Foundation Collaborative Project
