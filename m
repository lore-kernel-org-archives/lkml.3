Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbaFZCdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:33:36 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13993 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbaFZCdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:33:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 25 Jun 2014 19:27:25 -0700
Message-ID: <53AB867A.901@nvidia.com>
Date: Thu, 26 Jun 2014 11:33:30 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/2] ARM: firmware: Introduce suspend and resume operations
References: <1403713114-18923-1-git-send-email-t.figa@samsung.com> <1403713114-18923-2-git-send-email-t.figa@samsung.com>
In-Reply-To: <1403713114-18923-2-git-send-email-t.figa@samsung.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 01:18 AM, Tomasz Figa wrote:
> This patch extends the firmware_ops structure with two new callbacks:
> .suspend() and .resume(). The former is intended to ask the firmware to
> save all its volatile state and suspend the system, without returning
> back to the kernel in between. The latter is to be called early by
> very low level platform suspend code after waking up to restore low
> level hardware state, which can't be restored in non-secure mode.
>
> While at it, outdated version of the structure is removed from the
> documentation and replaced with a reference to the header file.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
