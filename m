Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaJMUCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:02:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaJMUCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:02:13 -0400
Message-ID: <543C2FC2.7020307@suse.cz>
Date: Mon, 13 Oct 2014 22:02:10 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: bjorn.forsman@gmail.com, computersforpeace@gmail.com,
        yamada.m@jp.panasonic.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kbuild changes for v3.18-rc1
References: <20141013195509.GA16541@pobox.suse.cz>
In-Reply-To: <20141013195509.GA16541@pobox.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.10.2014 v 21:55 Michal Marek napsal(a):
> Hi Linus,
> 
> please pull the following for v3.18-rc1:
> 
> * Fix for handling dependencies of *-objs targets by Masahiro Yamada
> * Lots of cleanups in the kbuild machinery, also by Masahiro
> * Fixes for the kconfig build to use an UTF-8 capable ncurses library if
>   possible and to build on not-so-standard installs
> * Some more minor fixes

Forgot to add: There is a conflict in arch/arm/mach-at91/Makefile. Use
the obj-y variable from master and remove the rest as done in kbuild.

Michal
