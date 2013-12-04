Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3LDVUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:20:23 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:63450 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3LDVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:20:20 -0500
Date: Wed, 4 Dec 2013 13:20:14 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mxc_nand: remove duplicated ecc_stats counting
Message-ID: <20131204212014.GB27149@ld-irv-0074.broadcom.com>
References: <1385730869-2322-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385730869-2322-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 02:14:29PM +0100, Michael Grzeschik wrote:
> The ecc_stats.corrected count variable will already be incremented in
> the above framework-layer just after this callback.
> 
> Cc: stable@vger.kernel.org

Added a 2.6.36+ note, just for reference.

> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Pushed to l2-mtd.git. Thanks!

Brian
