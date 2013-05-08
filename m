Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3EHVun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:50:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24332 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3EHVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:50:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,636,1363158000"; 
   d="scan'208";a="45526893"
Message-ID: <518AC8A4.8070701@codeaurora.org>
Date: Wed, 08 May 2013 14:50:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the decompressor
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/13 14:47, Stephen Boyd wrote:
> From: Brian Swetland <swetland@google.com>
>
> Currently v7 CPUs with an MIDR that has no bits set in the range
> [16:12] will be detected as old ARM CPUs with no caches and so

I mean [15:12], sorry.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

