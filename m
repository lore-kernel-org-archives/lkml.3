Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3DSSbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:31:04 -0400
Received: from sauhun.de ([89.238.76.85]:54382 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab3DSSbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:31:02 -0400
Date: Fri, 19 Apr 2013 20:30:57 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: =?utf-8?B?7Iah7J2A67SJ?= <eunb.song@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Fix i2c fail problem when a process is terminated
 by a signal on octeon in 3.8
Message-ID: <20130419183057.GA3702@the-dreams.de>
References: <11412343.361631366270816380.JavaMail.weblogic@epv6ml12>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11412343.361631366270816380.JavaMail.weblogic@epv6ml12>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 07:40:16AM +0000, 송은봉 wrote:
> 
> I rewrite my patch because the patch before i sent have many white space.
> Thanks!

This should have been below the "---" after the sigend-off.

> ---
> I've been debugging the abnormal operation of i2c on octeon.
> If a process is terminated by signal in the middle of i2c operation,
> next i2c read operation which is done by another process was failed.
> So i changed to ignore signal in the middle of i2c operation.
> After that the problem was not reproduced.
> 
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>

Applied to for-next, thanks!

