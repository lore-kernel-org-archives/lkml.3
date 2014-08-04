Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaHDVQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:16:49 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62336 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaHDVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:16:48 -0400
Date: Mon, 4 Aug 2014 14:16:44 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: use NULL instead of 0 for an address
Message-ID: <20140804211644.GX3711@ld-irv-0074>
References: <1406817076-1072-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406817076-1072-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 04:31:16PM +0200, Martin Kepplinger wrote:
> Use NULL instead of 0 when returning an address. This fixes a
> sparse warning.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> Sorry if this is only noise, I stumbled upon it and why not send it.
> applies to next-20140731

Queued to l2-mtd.git/next.

Brian
