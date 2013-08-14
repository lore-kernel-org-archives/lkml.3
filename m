Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3HNPdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:33:33 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47619 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HNPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:33:32 -0400
Date: Wed, 14 Aug 2013 16:33:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 4/4] added ams AS3722 register include file
Message-ID: <20130814153325.GG4046@lee--X1>
References: <1376492098-15672-1-git-send-email-florian.lobmaier@ams.com>
 <1376492098-15672-4-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376492098-15672-4-git-send-email-florian.lobmaier@ams.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
>  include/linux/mfd/as3722-reg.h |  495 ++++++++++++++++++++++++++++++++++++++++

So the way you've split up the patch isn't quite right. It shouldn't
be split by files, rather by functionality.

Quoting from Documentation/SubmittingPatches:

"If your changes produce a lot of deltas, you may want to look into
 splitting them into individual patches which modify things in
 logical stages.  This will facilitate easier reviewing by other
 kernel developers, very important if you want your patch accepted."

Note "logical stages".

So things like:

- Driver introduction including Kconfig and Makefile entries
- Resource allocation; memory and irqs
- Everything else, bit by bit

Within reason, the simpler the patches, they more likely they are to
be reviewed and accepted.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
