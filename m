Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab3ETVQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:16:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57512 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab3ETVQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:16:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,709,1363158000"; 
   d="scan'208";a="49068405"
Message-ID: <519A92BA.1090702@codeaurora.org>
Date: Mon, 20 May 2013 14:16:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v4 2/5] clk: move some parent related functions upwards
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com> <1369056507-32521-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1369056507-32521-3-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/13 06:28, James Hogan wrote:
> Move some parent related functions up in clk.c so they can be used by
> the modifications in the following patch which enables clock reparenting
> during set_rate. No other changes are made so this patch makes no
> functional difference in isolation. This is separate from the following
> patch primarily to ease readability of that patch.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

