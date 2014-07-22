Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaGVClx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:41:53 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63094 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaGVClw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:41:52 -0400
Date: Mon, 21 Jul 2014 19:41:48 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mtd: nand: add basic SDR NAND timings infrastructure
Message-ID: <20140722024148.GA7537@ld-irv-0074>
References: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 09:49:40AM +0200, Boris BREZILLON wrote:
> These two patches add SDR NAND timings definition and ONFI timing mode to
> NAND timings converter.
> 
> This infrastructure will be used by NAND controller drivers to configure
> their signal timings according to NAND chip capabilities.

Pushed both to l2-mtd.git, with the modification I noted in patch 2.
Thanks!

Brian
