Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3BCDKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:10:17 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:34762 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3BCDKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:10:15 -0500
Date: Sat, 2 Feb 2013 19:06:26 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] goldfish: power device
Message-ID: <20130203030626.GA25016@lizard.sbx00618.mountca.wayport.net>
References: <20130125152918.7277.7498.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130125152918.7277.7498.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 03:30:00PM +0000, Alan Cox wrote:
> From: Mike Lockwood <lockwood@android.com>
> 
> Add the emulated power driver for the Goldfish platform.
> 
> This folds together the code from the Google tree, Jun Nakajima's cleanups
> and x86 porting work, and then a tidy up to pass checkpatch.
> 
> Signed-off-by: Mike A. Chan <mikechan@google.com>
> [cleanup and x86 support]
> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
> Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
> Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
> Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
> [ported to 3.4]
> Signed-off-by: Tom Keel <thomas.keel@intel.com>
> [ported to 3.7 and final tidy]
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Applied, thank you!
