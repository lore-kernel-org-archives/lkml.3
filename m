Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaAZOXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 09:23:36 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64306 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaAZOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 09:23:35 -0500
X-Nat-Received: from [202.181.97.72]:61827 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1390746160.7700
To: thomas@archlinux.org, ak@linux.intel.com
Cc: viro@ZenIV.linux.org.uk, geert@linux-m68k.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <52E4CF03.8030208@archlinux.org>
In-Reply-To: <52E4CF03.8030208@archlinux.org>
Message-Id: <201401262322.DDF78613.FVSFOLOOJFHtQM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 26 Jan 2014 23:22:38 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 26012014 #7411188, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas B臘hler wrote:
> This looks exactly like the problem experienced by Tetsuo Handa in [1].
> However, for me, his solution, i.e. setting
>  CONFIG_PHYSICAL_ALIGN=0x1000000
> instead of
>  CONFIG_PHYSICAL_ALIGN=0x100000
> doesn't help and the symptoms stay the same (and, according to the
> documentation and to Kbuild, both are valid values on i686).

I tried your config with "make localmodconfig" and saw the symptoms. I changed
CONFIG_PHYSICAL_ALIGN from 0x100000 to 0x1000000 and no longer see the symptoms.
Did you save your config after changing CONFIG_PHYSICAL_ALIGN ?
