Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaCTHKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:10:32 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52844 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaCTHKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:10:30 -0400
Date: Thu, 20 Mar 2014 00:10:26 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DCG_UPD_stlinux_kernel@list.st.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, Angus.Clark@st.com
Subject: Re: [PATCH v6 01/35] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
Message-ID: <20140320071026.GA31517@norris-Latitude-E6410>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
 <1392735362-1245-2-git-send-email-lee.jones@linaro.org>
 <20140309053306.GL31517@norris-Latitude-E6410>
 <20140311082316.GJ2839@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311082316.GJ2839@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

I really can't take this patch separately. You'll need to resend the
whole series soon.

On Tue, Mar 11, 2014 at 08:23:16AM +0000, Lee Jones wrote:
> Sorry about the previous fixup misses. There were a couple of patches
> which I had failed to squash into the pack. Hopefully the rest of the
> review will go more smoothly.

Yeah... you missed a few more comments in the rest of the series too.
Can you please (for your own sake!) go through the rest of my comments
from before and see if you've missed any other important ones? I hate to
do the same work twice. The series mostly looks good, and I'd rather not
stall again for lack of attention to detail.

I'll comment on the couple of things I saw in just a bit.

Brian
