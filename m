Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaJTQy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:54:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60412 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaJTQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:54:24 -0400
Message-ID: <54453E3B.2050809@codeaurora.org>
Date: Mon, 20 Oct 2014 19:54:19 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: dedekind1@gmail.com, Joe Perches <joe@perches.com>
CC: ezequiel.garcia@free-electrons.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>	 <543D304C.5000607@codeaurora.org> <1413297205.3269.11.camel@joe-AO725>	 <1413299231.7906.101.camel@sauron.fi.intel.com>	 <1413302724.3269.18.camel@joe-AO725> <1413813074.7906.294.camel@sauron.fi.intel.com>
In-Reply-To: <1413813074.7906.294.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 4:51 PM, Artem Bityutskiy wrote:
> On Tue, 2014-10-14 at 09:05 -0700, Joe Perches wrote:
>> It's pretty trivial when all the lines are already
>> being touched.
>
> OK, but then the same change should done in UBIFS, because it's
> ubifs_msg() and so on macros are consistent with UBI macros. So I think
> if this is done, then it is done separately for both UBI and UBIFS.
>
> Artem.
>

We have similar patch for ubifs as well, one that adds ubi number to all 
ubifs messages. We just didn't get to sharing it yet.
I prefer not adding the "\n" to my patch unless Artem insists on it.

Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project
