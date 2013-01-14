Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3ANWQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:16:39 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37419 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ANWQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:16:38 -0500
Date: Mon, 14 Jan 2013 14:16:38 -0800
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, arm@kernel.org
Subject: Re: [GIT PULL] timer: vt8500: Move timer code to drivers/clocksource
Message-ID: <20130114221638.GA28091@quad.lixom.net>
References: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 06:09:30PM +1300, Tony Prisk wrote:
> Hi Olof,
> 
> Not sure if I have done this correctly but this is the patch to move the
> vt8500/timer.c code into drivers/clocksource.
> 
> I based it on timer/cleanup from armsoc (hopefully this is right - if not, a
> few pointers in the right direction would be appreciated).
> 
> Regards
> Tony P
> 
> 
> The following changes since commit 1c2584c3a1c882fec729147a46d822522552e38c:
> 
>   ARM: sunxi: fix struct sys_timer removal (2013-01-08 10:50:43 -0800)
> 
> are available in the git repository at:
> 
>   git://server.prisktech.co.nz/git/linuxwmt.git tags/vt8500/timer

Thanks, pulled and merged into next/cleanup.


-Olof
