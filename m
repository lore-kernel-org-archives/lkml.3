Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3C2THZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:07:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22112 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab3C2THX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:07:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,374,1363158000"; 
   d="scan'208";a="33871877"
Message-ID: <ac6067989f4390aee844926736e8c421.squirrel@www.codeaurora.org>
In-Reply-To: <20130328184922.GE19488@kernel.dk>
References: <1364202150-8776-1-git-send-email-tlinder@codeaurora.org>
    <20130325123410.GG22327@kernel.dk>
    <d6658b60b7e09376cfcf692dc54ac922.squirrel@www.codeaurora.org>
    <20130328184922.GE19488@kernel.dk>
Date: Fri, 29 Mar 2013 22:07:12 +0300
Subject: Re: [PATCH v5 1/3] block: Add support for reinsert a dispatched req
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: tlinder@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, alex.lemberg@sandisk.com,
        "open list" <linux-kernel@vger.kernel.org>
Reply-To: tlinder@codeaurora.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

>
> I said practically the same, not exactly the same! In any case, the
> point is that you could reuse the exact same infrastructure for this,
> instead of literally duplicating everything. Have some helper that does
> the grunt of the work, pass in whether or not you want the existing
> requeue event, or a reinsert event.
>

 Thank you for the input. Will do and upload a new patch.

Thanks,
Tanya Brokhman
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

