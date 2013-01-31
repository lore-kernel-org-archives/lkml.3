Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3AaNDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:03:48 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42939 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3AaNDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:03:45 -0500
Date: Thu, 31 Jan 2013 13:03:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ASoC: Ux500: Fix build error pertaining to missing
 include file
Message-ID: <20130131130340.GB2042@gmail.com>
References: <1359635640-1932-1-git-send-email-lee.jones@linaro.org>
 <20130131123744.GG11078@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130131123744.GG11078@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Mark Brown wrote:

> On Thu, Jan 31, 2013 at 12:34:00PM +0000, Lee Jones wrote:
> > Some compilers complain when building sound for MOP500:
> > 
> > sound/soc/ux500/mop500.c:27:27:
> >         fatal error: mop500_ab8500.h: No such file or directory
> 
> Should be kernel version dependant I expect...

What do you mean?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
