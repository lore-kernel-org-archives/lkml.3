Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaBNNrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:47:43 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55060 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaBNNrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:47:41 -0500
Message-ID: <52FE1E81.2040101@cogentembedded.com>
Date: Fri, 14 Feb 2014 17:47:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-sh@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 27/27] ARM: shmobile: koelsch-reference: Enable CMT0 in
 device tree
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1392339605-20691-28-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1392339605-20691-28-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-02-2014 5:00, Laurent Pinchart wrote:

> Enable the CMT0 device and configure channel 0 as a clock event
> provider.

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>   arch/arm/boot/dts/r8a7791-koelsch.dts            |  9 +++++++++
>   arch/arm/mach-shmobile/board-koelsch-reference.c | 15 +--------------
>   arch/arm/mach-shmobile/include/mach/r8a7791.h    |  1 -
>   arch/arm/mach-shmobile/setup-r8a7791.c           |  7 +------

    The latter 2 files are worth splitting into a separate patch as well...

>   4 files changed, 11 insertions(+), 21 deletions(-)

WBR, Sergei

