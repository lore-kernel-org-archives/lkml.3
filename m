Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaCXCC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:02:27 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51401 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaCXCCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:02:25 -0400
Date: Mon, 24 Mar 2014 11:02:16 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH] ARM: shmobile: r8a7778/bockw: Move "select
 RENESAS_INTC_IRQPIN" under SoC
Message-ID: <20140324020216.GE8777@verge.net.au>
References: <1395603378-32199-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395603378-32199-1-git-send-email-geert@linux-m68k.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 08:36:18PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Move the "select RENESAS_INTC_IRQPIN" from the two bockw-specific sections
> to the one r8a7778-specific section, like is done for the other SoCs.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Thanks, I have queued-up this patch.
