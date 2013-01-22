Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3AVVHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:07:47 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48116 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3AVVHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:07:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,516,1355126400"; 
   d="scan'208";a="21507537"
Message-ID: <50FEFF9F.1060305@codeaurora.org>
Date: Tue, 22 Jan 2013 13:07:43 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: Add %pa format specifier for phys_addr_t
 types
References: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>  <1358839767.12502.44.camel@smile> <1358841145.23968.28.camel@joe-AO722>
In-Reply-To: <1358841145.23968.28.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2013 11:52 PM, Joe Perches wrote:
> I believe this should be:
>
> 	spec.field_width = sizeof(phys_addr_t) * 2 + 2;
>

Ah yes, I believe you are right. I had only added the SPECIAL flag after 
writing this. Will fix in v2.

-- 
  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
  hosted by The Linux Foundation
