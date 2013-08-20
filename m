Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab3HTXgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:36:22 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52262 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3HTXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:36:21 -0400
Date: Tue, 20 Aug 2013 16:36:13 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] m25p80 / fast read
Message-ID: <20130820233613.GA28382@ld-irv-0074.broadcom.com>
References: <1376985281-16293-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376985281-16293-1-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:54:38AM +0200, Sascha Hauer wrote:
> 
> Changes since v1:
> 
> - rebase on git.infradead.org/l2-mtd.git
> - improve description for patch 2/3

Thanks for these.

> Sascha
> 
> ----------------------------------------------------------------
> Markus Niebel (1):
>       mtd: m25p80: add support for mr25h10
> 
> Sascha Hauer (2):
>       mtd: m25p80: Pass flags through CAT25_INFO macro
>       mtd: m25p80: make CONFIG_M25PXX_USE_FAST_READ safe to enable
> 
>  drivers/mtd/devices/m25p80.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)

Pushed to l2-mtd.git.

Brian
