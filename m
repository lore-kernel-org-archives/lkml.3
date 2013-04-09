Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935844Ab3DIJFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:05:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:4482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935462Ab3DIJFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:05:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="283563957"
Date: Tue, 9 Apr 2013 11:05:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: ab8500-core: Add of_compatilbe property for
 ab8500-usb
Message-ID: <20130409090501.GF23447@zurbaran>
References: <1365497841-4640-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365497841-4640-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Tue, Apr 09, 2013 at 10:57:21AM +0200, Fabio Baltieri wrote:
> Add of_comptabile string to the ab8500-usb cell to allow the driver to
> grab properties from device-tree when available.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
> 
> Hi Samuel,
> 
> this oneline allows the driver to grab regulators and other attributes
> from device tree.
> 
> This is actually generated on top of -next, so it should apply cleanly on
> your current mfd-next tree.  If it doesn't, I'll rebase on your updated
> tree when available.
It applies cleanly, I just pushed it now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
