Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3HBOae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:30:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab3HBOad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:30:33 -0400
Date: Fri, 2 Aug 2013 16:30:32 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Fabio Estevam <festevam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: "watchdog: update watchdog_tresh properly" breaks non-SMP
Message-ID: <20130802143032.GJ25432@dhcp22.suse.cz>
References: <CAOMZO5BFmsLqj5iRKbmTEvLa3J3CwtN3s7P0qiE_x9aQ6tEJbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5BFmsLqj5iRKbmTEvLa3J3CwtN3s7P0qiE_x9aQ6tEJbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-08-13 11:19:50, Fabio Estevam wrote:
> Hi Michal,
> 
> Commit 0ce6966b5 (watchdog: update watchdog_tresh properly) breaks the
> build for uniprocessor systems:
> 
> kernel/watchdog.c: In function ‘update_timers’:
> kernel/watchdog.c:523:2: error: implicit declaration of function
> ‘__smp_call_function_single’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [kernel/watchdog.o] Error 1

I have already sent a patch to fix this here:
https://lkml.org/lkml/2013/8/1/104

Sorry about inconvenience.

-- 
Michal Hocko
SUSE Labs
