Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaGCAuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:50:22 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:61147 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGCAuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:50:21 -0400
Date: Wed, 2 Jul 2014 17:50:16 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140703005016.GB7537@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, there are a few checkpatch.pl complaints. Please fix these for the
next version (v2 or v3?)

On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
> This is a squashed version of the submission to avoid re-sending the
> entire set over and over, essentially clogging up the MLs.
> 
> Cc: computersforpeace@gmail.com
> Cc: Gupta, Pekon" <pekon@ti.com>

Stray/unbalanced quote character?

> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

[...]

Brian
