Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab3DNMUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 08:20:47 -0400
Received: from sauhun.de ([89.238.76.85]:47921 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3DNMUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 08:20:41 -0400
Date: Sun, 14 Apr 2013 14:20:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 08/30] i2c: s3c2410: make header file local
Message-ID: <20130414122035.GB9013@the-dreams.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-9-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365638712-1028578-9-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 02:04:50AM +0200, Arnd Bergmann wrote:

> No other file in the kernel besides i2c-s3c2410.c uses the current
> plat/regs-iic.h, so we can simply move the header file to live in the
> same directory as the driver, as a preparation to multiplatform builds.

What about putting the regs in the driver itself?

