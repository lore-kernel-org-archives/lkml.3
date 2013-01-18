Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab3ARQBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:01:18 -0500
Received: from linux-sh.org ([111.68.239.195]:45497 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3ARQBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:01:17 -0500
Date: Sat, 19 Jan 2013 01:01:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 28/76] ARC: I/O and DMA Mappings
Message-ID: <20130118160106.GD14019@linux-sh.org>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358511930-7424-29-git-send-email-vgupta@synopsys.com>
 <201301181555.43487.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301181555.43487.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 03:55:43PM +0000, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
> > TBD: Do we need early ioremap support like openrisc
> > 
> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> 
> Can you explain why early ioremap is necessary for you?
> 
> I wasn't aware that openrisc has it. In a lot of cases,
> you can use fixmap as a replacement.
> 
The two don't need to be mutually exclusive, either. sh implements early
ioremap transparently via fixmaps for example:

	arch/sh/mm/ioremap.c
	arch/sh/mm/ioremap_fixed.c
