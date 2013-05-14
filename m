Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab3ENUHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:07:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47318 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3ENUHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:07:07 -0400
Date: Tue, 14 May 2013 22:06:23 +0200
From: Jens Axboe <axboe@kernel.dk>
To: OS Engineering <osengineering@stec-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>,
        Carlos Alonso <calonso@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: EnhanceIO kernel driver
Message-ID: <20130514200623.GK587@kernel.dk>
References: <A44CB407BBB85C498149811C52498A45075275@MYMBX3.stec-inc.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A44CB407BBB85C498149811C52498A45075275@MYMBX3.stec-inc.ad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14 2013, OS Engineering wrote:
> Hi Jens,
> 
> Kindly find an updated EnhanceIO(TM) software kernel driver attached
> herewith. Continuing with our previous communication: we request you
> to include it in Linux kernel.

The situation has changed a bit since last. We know have both dm-cache
and bcache in the kernel. What does this solution bring to the table,
that those two do not already cover?

IOW, we need a bit of a better sales pitch than "here it is".

-- 
Jens Axboe

