Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab3DYA0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:26:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37964 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab3DYA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:26:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,546,1363158000"; 
   d="scan'208";a="41158754"
Message-ID: <5178782B.1080802@codeaurora.org>
Date: Wed, 24 Apr 2013 17:26:19 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jonghwan Choi <jhbird.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3.8-stable] ARM: 7699/1: sched_clock: Add more notrace
 to prevent
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com> <001501ce414a$14da9de0$3e8fd9a0$%choi@samsung.com>
In-Reply-To: <001501ce414a$14da9de0$3e8fd9a0$%choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/13 17:16, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?

Sure.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

