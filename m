Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AVUXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:23:43 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:62954 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3AVUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:23:42 -0500
Message-ID: <50FEF54C.40209@tilera.com>
Date: Tue, 22 Jan 2013 15:23:40 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <linux-kernel@vger.kernel.org>, <lttng-dev@lists.lttng.org>
Subject: Re: [PATCH 4/4] tile: select HAVE_SYSCALL_TRACEPOINTS
References: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca> <1358816098-13070-4-git-send-email-simon.marchi@polymtl.ca>
In-Reply-To: <1358816098-13070-4-git-send-email-simon.marchi@polymtl.ca>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2013 7:54 PM, Simon Marchi wrote:
> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
> ---
>  arch/tile/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Thanks!

I took the series of four patches into the tile tree for 3.9 (removing the parentheses around the definition of NR_syscalls).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

