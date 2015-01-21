Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbbAUOLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:11:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbbAUOLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:11:09 -0500
Date: Wed, 21 Jan 2015 15:11:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Miao <realmz6@gmail.com>
cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Randy Dunlap <rdunlap@infradead.org>, Christoph Lameter <cl@linux.com>,
        Masanari Iida <standby24x7@gmail.com>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blackfin: mach-common: ints-priority: Remove unused
 function
In-Reply-To: <CAMk6uBk8gPAsKKqZPC=9dxRkiXm7893SwK1fd6J4Bc+iVkG+uA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1501211510220.10817@pobox.suse.cz>
References: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <alpine.LNX.2.00.1501201407050.10817@pobox.suse.cz> <CAMk6uBk8gPAsKKqZPC=9dxRkiXm7893SwK1fd6J4Bc+iVkG+uA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Steven Miao wrote:

> > This doesn't seem to be present in linux-next as of today, so I am picking
> > it up.
> It seems it's still in today's linux-next?
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/blackfin/mach-common/ints-priority.c#n432

Your "today" probably differs from mine :) The commit that removes it has 
appeared in linux-next ~6 hours ago.

http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=4d2ffaa99c7a685dabab5c8c56b58286fd679bd5

-- 
Jiri Kosina
SUSE Labs
