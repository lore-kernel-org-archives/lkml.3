Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161397AbaDQFNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:13:45 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41875 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaDQFNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:13:43 -0400
Date: Wed, 16 Apr 2014 22:13:38 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Lee Jones <lee.jones@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: fsl-quadspi: fix __iomem annotations
Message-ID: <20140417051338.GI5512@norris-Latitude-E6410>
References: <1397638079-1894-1-git-send-email-computersforpeace@gmail.com>
 <534E4528.6030700@freescale.com>
 <20140416091512.GG5512@norris-Latitude-E6410>
 <534E4BA7.2040901@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534E4BA7.2040901@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 05:21:43PM +0800, Huang Shijie wrote:
> 于 2014年04月16日 17:15, Brian Norris 写道:
> >Pushed to l2-mtd.git/spinor.
> I think you can rebase patches in the spinor branch to the master
> branch now.

I merged spinor into master for now, so it will be in -next. I think
I'll keep the separate branch, in case we need something stable for
others to pull in.

> After the rebase, we can add the patch for the *defconfig for the
> linux-next.

Yeah, I guess we should send patches. I'll try to do that soon.

Brian
