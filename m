Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3I3NdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:33:21 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:59880 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3I3NdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:33:18 -0400
Date: Mon, 30 Sep 2013 15:33:11 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] MIPS: Alchemy: MTX-1: fix incorrect placement of
 __initdata tag
Message-ID: <20130930133311.GA12077@linux-mips.org>
References: <1426447.xVtcA00boF@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426447.xVtcA00boF@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 03:09:20PM +0200, Bartlomiej Zolnierkiewicz wrote:

> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.

Thanks Bart, applied.

  Ralf
