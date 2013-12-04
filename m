Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3LDU7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:59:22 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:47682 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3LDU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:59:21 -0500
Date: Wed, 4 Dec 2013 21:59:16 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: hskinnemoen@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: pm: Fix section mismatch
Message-ID: <20131204205916.GB6229@samfundet.no>
References: <1386175975-18173-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386175975-18173-1-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 04 Dec 2013 17:52:55 +0100 or thereabout, Matthias Brugger wrote:
> The power management has a section mismatch which leads to the following
> warning during compilation:
> 
> WARNING: arch/avr32/mach-at32ap/built-in.o(.text+0x16d4): Section
> mismatch in reference from the function avr32_pm_offset() to the
> function .init.text:pm_exception()
> The function avr32_pm_offset() references
> the function __init pm_exception().

Thank you for fixing, I'll add this to my for-linus branch.

> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/mach-at32ap/pm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
