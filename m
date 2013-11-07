Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3KGLy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:54:58 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39223 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3KGLyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:54:55 -0500
Date: Thu, 7 Nov 2013 11:54:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH 3/7] ARM: ux500: Remove ATAG support for SDI (MMC)
Message-ID: <20131107115448.GO30901@lee--X1>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
 <1383732348-18576-4-git-send-email-lee.jones@linaro.org>
 <20131107114654.GF16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131107114654.GF16735@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Nov 2013, Russell King - ARM Linux wrote:

> On Wed, Nov 06, 2013 at 10:05:44AM +0000, Lee Jones wrote:
> > This hasn't been used since we moved over to a Device Tree only platform.
> 
> The patch summary line is slightly off.  There's nothing here to do with
> ATAGs.

Oh I see. Yes you're right, it was just what Arnd, myself and a few
others called non-DT 'cos it was easier.

Linus are you happy to fixup the subject lines of these two commits or
would you like me to re-submit?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
