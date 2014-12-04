Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbaLDSSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:18:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40440 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaLDSS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:18:29 -0500
Message-ID: <5480A573.4090801@codeaurora.org>
Date: Thu, 04 Dec 2014 10:18:27 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, linux-kernel@vger.kernel.org
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
References: <1417707993-82290-1-git-send-email-agraf@suse.de>
In-Reply-To: <1417707993-82290-1-git-send-email-agraf@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/2014 7:46 AM, Alexander Graf wrote:
> With binutils 2.25 the default alignment for 32bit arm sections changed to
> have everything 64k aligned. Armv7 binaries built with this binutils version
> run successfully on an arm64 system.
>
> Since effectively there is now the chance to run armv7 code on arm64 even
> with 64k page size, it doesn't make sense to block people from enabling
> CONFIG_COMPAT on those configurations.
>

It's good to see this restriction dropped. Can we put a note somewhere
in the actual Kconfig about the binutils requirement so the requirements
are more obvious?

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
