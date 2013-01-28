Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3A1Inf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:43:35 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:36809 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3A1Ind (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:43:33 -0500
Date: Mon, 28 Jan 2013 08:43:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 05/26] mfd: ab8500-gpadc: Change to mdelay for greater
 resolution
Message-ID: <20130128084325.GA15873@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-6-git-send-email-lee.jones@linaro.org>
 <20130127235239.GM1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130127235239.GM1174@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Samuel Ortiz wrote:

> Hi Lee, Jonas,
> 
> On Tue, Jan 15, 2013 at 12:55:45PM +0000, Lee Jones wrote:
> > From: Jonas Aaberg <jonas.aberg@stericsson.com>
> > 
> > The resolution of msleep is related to HZ, so with HZ set to
> > 100 any msleep of less than 10ms will become ~10ms.
> usleep_range would be more appropriate, sleeping should be preferred over
> spinning.

I believe this patch was written before usleep_range() was around. This
is addressed in a latter patch. Please allow this one in for a)
historical reasons (trying to keep the development history) and b) to
prevent any conflicts when we do reach the fixup patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
