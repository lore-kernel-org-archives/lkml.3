Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3DWUr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:47:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:52696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3DWUrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:47:55 -0400
Message-ID: <5176F364.1080101@infradead.org>
Date: Tue, 23 Apr 2013 13:47:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-cris-kernel@axis.com, uclinux-dist-devel@blackfin.uclinux.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Build regressions/improvements in v3.9-rc8
References: <alpine.DEB.2.00.1304232131300.11127@ayla.of.borg> <alpine.DEB.2.00.1304232132050.11155@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1304232132050.11155@ayla.of.borg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/13 12:35, Geert Uytterhoeven wrote:
>   + error: "vm_iomap_memory" [drivers/video/fb.ko] undefined!:  => N/A
>   
> bfin/BF537-STAMP_defconfig


This is a result of the recent iomap changes (I think).

Can Blackfin and others handle a change to FB that says:

	depends on MMU

??
then generic fb.o will not be built for no-MMU architectures.

-- 
~Randy
