Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJIUpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:45:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46657 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJIUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:45:30 -0400
Date: Thu, 9 Oct 2014 13:45:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/8] MIPS: Alchemy: Remove direct access to
 prepare_count field of struct clk
Message-ID: <20141009204528.GF5493@codeaurora.org>
References: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412866903-6970-2-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412866903-6970-2-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Tomeu Vizoso wrote:
> Replacing it with a call to __clk_is_prepared(), which isn't entirely
> equivalent but in practice shouldn't matter.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
