Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285Ab3DOVyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:54:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63099 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab3DOVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:54:38 -0400
Date: Mon, 15 Apr 2013 23:54:32 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Michal Marek <mmarek@suse.cz>, Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] menuconfig: Fix memory leak introduced by jump keys
 feature
Message-ID: <20130415215432.GB12519@free.fr>
References: <1366035231-24370-1-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366035231-24370-1-git-send-email-bpoirier@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, All,

On Mon, Apr 15, 2013 at 10:13:50AM -0400, Benjamin Poirier wrote:
> Fixes the memory leak of struct jump_key allocated in get_prompt_str()

Queued into:
https://git.gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-rc-fixes

Although this is strictly a bug fix, I would lean toward waiting for the
next merge window to open before pulling this in.

We can't really say that the kconfig frontends are critical, long-running
processes. If they leak a bit of memory, that's not too cumbersome, I
think. OTOH, I think breaking the frontends so close to the end of the
-rc cycle is a bit dangerous (heck, I would not like to be part of the
cause of a new flaming, just for this! ;-) )

So, unless Michal really wants to pull this one and push it to Linus
before he cuts v3.9 final, I'll merge this later in my -for-next branch.

Thank you!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
