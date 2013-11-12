Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab3KLVYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:24:15 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:40126 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLVYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:24:05 -0500
Message-ID: <52829C68.6090409@twiddle.net>
Date: Wed, 13 Nov 2013 07:23:52 +1000
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 01/17] alpha: Use Kbuild logic to include <asm-generic/sections.h>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 05:42 AM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/include/asm/Kbuild     |    2 +-
>  arch/alpha/include/asm/sections.h |    7 -------
>  2 files changed, 1 insertion(+), 8 deletions(-)
>  delete mode 100644 arch/alpha/include/asm/sections.h

Acked-by: Richard Henderson <rth@twiddle.net>


r~
