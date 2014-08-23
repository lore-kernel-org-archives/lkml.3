Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaHWFs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 01:48:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60922 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaHWFs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 01:48:56 -0400
Date: Fri, 22 Aug 2014 21:17:34 -0700
From: Olof Johansson <olof@lixom.net>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 00/11] ARM: multi_v7_defconfig: Enable Zynq/Xilinx drivers
Message-ID: <20140823041734.GA11268@localhost>
References: <1408722876-7791-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408722876-7791-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 08:54:25AM -0700, Soren Brinkmann wrote:
> Hi,
> 
> I went through the defconfig and searched for Zynq drivers. The result is
> this series of patches. The first few are all for Zynq and pretty much
> straight forward. The second half is mostly soft-IP, I think. That
> soft-IP works with Zynq devices, but I'm not sure whether those should
> go into the multi_v7 defconfig.

Thanks, SÃren! 

There's no need to split up into individual patches like this, but it was
convenient in case I wanted to only apply a few of them. I took them all
as one patch, and used your series description as commit message since
none of the individual patches had any. :)

As far as "unusual" drivers in the multiconfig; yeah, we need to deal
with that at some point due to kernel size. We're likely to switch ti
using modules first, but it'll make things slightly more complicated
since people will need to start dealing with initrds and at least I
don't have a good setup for that in my test farm yet. :-)


-Olof
