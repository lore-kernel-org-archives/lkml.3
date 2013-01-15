Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3AONGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:06:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33468 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619Ab3AONGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:06:44 -0500
Date: Tue, 15 Jan 2013 22:06:36 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com
Subject: Re: [PATCH 12/26] mfd: ab8500-debugfs: Use NULL to initialise
 remaining NULL pointer
Message-ID: <20130115130635.GH5701@opensource.wolfsonmicro.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-13-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-13-git-send-email-lee.jones@linaro.org>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 12:55:52PM +0000, Lee Jones wrote:
> Partly for coding style reasons, but mostly because sparse warns on it.
> 
> This patch is a completion of a previous patch my Mark Brown.

Typo there :)

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
