Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaGJSUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:20:03 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60650 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaGJSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:20:01 -0400
X-CheckPoint: {53BED950-6-2100090A-C0000000}
Message-ID: <53BED94F.9020407@tilera.com>
Date: Thu, 10 Jul 2014 14:19:59 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: Add underscores to defintions
References: <1404534728-7345-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1404534728-7345-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.20.112.127]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/2014 12:32 AM, Nicholas Krause wrote:
> In file drv_xgbe_impl.h I fixed the definitions for Size Small,
> Size Large, Size Jumbo to have underscores before and after to
> follow kernel coding style for internel defentions.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   arch/tile/include/hv/drv_xgbe_impl.h | 15 +++------------

I don't think there is a kernel coding style for internal definitions.
It's true that double-underscores mean "more raw" in many places, like
for things like set_bit() vs __set_bit(), but that's not really
applicable here.  These files are not exported outside of the kernel
in any case so we don't need any special treatment for them to mark them
as "internal definitions".

The comment in any case certainly is silly.  It dates back to Jan 2007
in our internal version control system.  The tilepro hv headers in
question are largely frozen at this point in our internal "upstream"
repository where we take these headers from, so it doesn't seem worth
the effort to try to improve the comments there, nor worth adding skew
between those headers and the community headers.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

