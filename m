Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3AOTAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:00:11 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:44092 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab3AOTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:00:08 -0500
Date: Tue, 15 Jan 2013 11:00:09 -0800
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, swarren@wwwdotorg.org
Subject: Re: [PATCH] timer: vt8500: Convert vt8500 to use CLKSRC_OF
Message-ID: <20130115190009.GA28251@quad.lixom.net>
References: <1358232649-19964-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358232649-19964-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 07:50:49PM +1300, Tony Prisk wrote:
> This patch converts arch-vt8500 to make use of CLKSRC_OF. Doing so
> removes the need for include/linux/vt8500_timer.h as vt8500_timer_init
> no longer needs to be visible outside vt8500_timer.c
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> Hi Olof,
> 
> Here is the fix as requested by Stephen Warren, based on vt8500/timer.

Applied, thanks.


-Olof
