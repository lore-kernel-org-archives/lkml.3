Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbbAVOyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:54:47 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:46190 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbbAVOyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:54:46 -0500
Date: Thu, 22 Jan 2015 14:54:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c: i2c-st: Rename clock reference to something
 that exists
Message-ID: <20150122145440.GD9129@x1>
References: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
 <20150122121819.GC9129@x1>
 <20150122141427.GA3413@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150122141427.GA3413@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Wolfram Sang wrote:

> On Thu, Jan 22, 2015 at 12:18:19PM +0000, Lee Jones wrote:
> > Wolfram,
> > 
> > This patch has been on the list since forever.
> 
> For reasons :)
> 
> a) It was not CCed to the i2c list, so it doesn't show up in patchwork
> which does the patch tracking for me.
> 
> b) I was always under the impression that Maxime is going to take it?
> He said so.
> 
> > I have Acks from the driver author, so I'm going to take this through
> > the MFD tree.  If you perk up later and decide to take it though the
> > I2C tree instead, let me know and I'll remove it from MFD.
> 
> Well, I2C makes more sense than MFD, so I'll pick it up right now.
> ST-tree would have also been fine.

Works for me.  Thanks dude.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
