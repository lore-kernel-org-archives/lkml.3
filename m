Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaAEBI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 20:08:58 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52249 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbaAEBI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 20:08:57 -0500
X-Nat-Received: from [202.181.97.72]:54235 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388884125.14012
To: chris@chris-wilson.co.uk
Cc: ben@bwidawsk.net, daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer dereference.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp>
	<20131225215249.GA3832@nuc-i3427.alporthouse.com>
	<201401032042.BJF09317.FJFQOFOVtSOLMH@I-love.SAKURA.ne.jp>
	<20140103125151.GA4367@nuc-i3427.alporthouse.com>
In-Reply-To: <20140103125151.GA4367@nuc-i3427.alporthouse.com>
Message-Id: <201401051008.FFH69706.JLOVMFFSQFHOOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 5 Jan 2014 10:08:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04012014 #7249268, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson wrote:
> > Then, this file->pid in &dev->filelist keeps at least one reference.
> > OK. Updated patch follows.
> 
> Looks good to me, and the comment is great.
> -Chris

Please pick up this patch via your git tree.

Also, please change from "<unknown>" to whatever you like. For example,
dump_holder() in fs/gfs2/glock.c uses "(ended)" if comm is not available.
