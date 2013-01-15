Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3AONtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:49:17 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:43524 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3AONtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:49:11 -0500
Date: Tue, 15 Jan 2013 13:49:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com
Subject: Re: [PATCH 12/26] mfd: ab8500-debugfs: Use NULL to initialise
 remaining NULL pointer
Message-ID: <20130115134905.GA9379@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-13-git-send-email-lee.jones@linaro.org>
 <20130115130635.GH5701@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130115130635.GH5701@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Mark Brown wrote:

> On Tue, Jan 15, 2013 at 12:55:52PM +0000, Lee Jones wrote:
> > Partly for coding style reasons, but mostly because sparse warns on it.
> > 
> > This patch is a completion of a previous patch my Mark Brown.
> 
> Typo there :)

Yes, it should say "patch by my Mark Brown". ;)

> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks. I'll fixup with the typo.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
