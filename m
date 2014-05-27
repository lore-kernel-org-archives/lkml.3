Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaE0QqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:46:12 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44778 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaE0QqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:46:07 -0400
Date: Tue, 27 May 2014 09:46:18 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        ARM Maintainers <arm@kernel.org>, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>
Subject: Re: [PATCH] ARM: at91/defconfig: sama5_defconfig: updated
Message-ID: <20140527164618.GA21482@quad.lixom.net>
References: <1401194721-22586-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401194721-22586-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:45:21PM +0200, Nicolas Ferre wrote:
> From: Wenyou Yang <wenyou.yang@atmel.com>
> 
> due to enabling
> 	-- CONFIG_REGULATOR
> 	-- CONFIG_REGULATOR_ACT8865
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> [nicolas.ferre@atmel.com: move added entries to proper location within file]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi Arnd, Olof, Kevin,
> 
> I have this little patch lying around without other updates to AT91
> defconfig files so far. Is it possible to take this patch in arm-soc
> without a pull-request?

Certainly. Applied to next/defconfig.


-Olof
