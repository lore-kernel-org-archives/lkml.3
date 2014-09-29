Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaI2AxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:53:12 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:40039 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaI2AxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:53:10 -0400
Date: Mon, 29 Sep 2014 01:53:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Isamu Mogi <isamu@leafytree.jp>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: R3000: Fix debug output for Virtual page number
In-Reply-To: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
Message-ID: <alpine.LFD.2.11.1409290145370.21156@eddie.linux-mips.org>
References: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Isamu Mogi wrote:

> Virtual page number of R3000 in entryhi is 20 bit from MSB. But in
> dump_tlb(), the bit mask to read it from entryhi is 19 bit (0xffffe000).
> The patch fixes that to 0xfffff000.
> 
> Signed-off-by: Isamu Mogi <isamu@leafytree.jp>

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 It would be good to add appropriate macros to <asm/mipsregs.h> too, to 
avoid magic numbers and decrease the likelihood of issues like this.  As a 
separate change, that is, of course, and not a prerequisite.

  Maciej
