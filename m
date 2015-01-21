Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbbAUAPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:15:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33919 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbAUAPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:15:39 -0500
Date: Tue, 20 Jan 2015 16:15:37 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v10 0/3] Per-user clock constraints
Message-ID: <20150121001537.GF27202@codeaurora.org>
References: <1421760306-6301-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421760306-6301-1-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Tomeu Vizoso wrote:
> 
> A rough test module was used to test this:
> 
> http://cgit.collabora.com/git/user/tomeu/linux.git/tree/drivers/misc/clk-test.c?h=per-user-clk-constraints-v10
> 

Would it be possible to also send a patch for this? It would be
nice to have some unit test module for the entire framework and
this could be the start of such a module.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
