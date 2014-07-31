Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaGaUfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:35:04 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33710 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaGaUfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:35:01 -0400
X-CheckPoint: {53DAA874-5-2100090A-C0000000}
Message-ID: <53DAA874.40209@tilera.com>
Date: Thu, 31 Jul 2014 16:35:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@sigma-star.at>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 20/43] tile: Use get_signal() signal_setup_done()
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at> <1405951409-16953-21-git-send-email-richard@sigma-star.at>
In-Reply-To: <1405951409-16953-21-git-send-email-richard@sigma-star.at>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/2014 10:03 AM, Richard Weinberger wrote:
> From: Richard Weinberger<richard@nod.at>
>
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.
>
> Signed-off-by: Richard Weinberger<richard@nod.at>
> ---
>   arch/tile/include/asm/compat.h   |  3 +--
>   arch/tile/kernel/compat_signal.c | 29 ++++++++++-----------
>   arch/tile/kernel/signal.c        | 54 ++++++++++++++++++----------------------
>   3 files changed, 40 insertions(+), 46 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

