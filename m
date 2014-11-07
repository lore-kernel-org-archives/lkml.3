Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaKGEQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:16:10 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34081 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaKGEQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:16:07 -0500
Message-ID: <545C4783.8070506@nvidia.com>
Date: Thu, 06 Nov 2014 21:16:03 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anatol Pomozov <anatol.pomozov@gmail.com>
CC: Marc Zyngier <marc.zyngier@arm.com>, mark.rutland@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: Copy register_persistent_clock() to arm64
 source subtree
References: <1415319665-21701-1-git-send-email-anatol.pomozov@gmail.com> <CAOMFOmXDqhwCk1pRf_9yGycboMqt-ZE33y=kZrhbqXOjVcrxYQ@mail.gmail.com>
In-Reply-To: <CAOMFOmXDqhwCk1pRf_9yGycboMqt-ZE33y=kZrhbqXOjVcrxYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 05:25 PM, Anatol Pomozov wrote:
> +Stephen
> 
> This patch is for tegra20_timer that uses register_persistent_clock().
> I did not find any way to share the same arch code for arm/arm64.
> 
> Actually this register_persistent_clock() does not look arm specific
> at all. Would it be better to move it somewhere outside of arch/?

No CC to linux-tegra@ or the other Tegra maintainers?

Yes, I think it'd be best not to have arch-specific APIs, or cut/paste
the same code into multiple places.
