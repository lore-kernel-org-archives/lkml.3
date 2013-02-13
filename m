Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426Ab3BMUzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:55:24 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:58672 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933985Ab3BMUzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:55:23 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [GIT PULL] removal of 1980s PC-XT MFM 8bit ISA disk driver
Date: Wed, 13 Feb 2013 21:54:37 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20130213200432.GA11018@windriver.com>
In-Reply-To: <20130213200432.GA11018@windriver.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201302132154.38477.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2013 21:04:32 Paul Gortmaker wrote:
> Jens,
>
> Please pull the following to get the removal of the original IBM PC-XT
> hard disk driver from the block layer (drivers/block/xd.c).
>
> As near as I can tell, it hasn't seen a run time fix in over a dozen
> years, and with drive sizes of 10-20MB, and performance of about 128kB/s
> maximum, it is no surprise that it has been completely unused for well
> over a decade.

It was fixed just yesterday by Linus Walleij: 
http://lkml.org/lkml/2013/2/12/541

-- 
Ondrej Zary
