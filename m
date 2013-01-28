Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3A1Ipy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:45:54 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49773 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3A1Ipu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:45:50 -0500
Date: Mon, 28 Jan 2013 08:45:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 14/26] mfd: ab8500-debugfs: Fix introduced compiler time
 warnings
Message-ID: <20130128084544.GD15873@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-15-git-send-email-lee.jones@linaro.org>
 <20130127235327.GR1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130127235327.GR1174@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Tue, Jan 15, 2013 at 12:55:54PM +0000, Lee Jones wrote:
> > From: Philippe Langlais <philippe.langlais@stericsson.com>
> > 
> > Some simple fixes regarding pre-processor usage.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> > ---
> >  drivers/mfd/ab8500-debugfs.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> Here again, please squash this one with the previous one.

I'll fixup.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
