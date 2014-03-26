Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaCZHej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:34:39 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47472 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZHeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:34:37 -0400
Date: Wed, 26 Mar 2014 00:34:33 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Erico Nunes <nunes.erico@gmail.com>
Cc: dwmw2@infradead.org, b32955@freescale.com,
        artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: fix mention to CONFIG_MTD_NAND_ECC_BCH
Message-ID: <20140326073433.GC31517@norris-Latitude-E6410>
References: <1394512286-31481-1-git-send-email-nunes.erico@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394512286-31481-1-git-send-email-nunes.erico@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 01:31:26AM -0300, Erico Nunes wrote:
> Mention to CONFIG_MTD_ECC_BCH in the warning message can be confusing as this
> doesn't match the exact name of the configuration option.
> This warning showed up once to me when I was starting to set up BCH. After
> checking my .config file, it took a moment before realizing it is
> CONFIG_MTD_NAND_ECC_BCH instead of CONFIG_MTD_ECC_BCH.
> 
> Signed-off-by: Erico Nunes <nunes.erico@gmail.com>

Pushed to l2-mtd.git. Thanks!

Brian
