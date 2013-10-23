Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JWMCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:02:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44969 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3JWMCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:02:37 -0400
Date: Wed, 23 Oct 2013 13:02:32 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Akhil Bhansali <Akhil.Bhansali@hgst.com>
Cc: OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "'linux kernel (linux-kernel@vger.kernel.org)'" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] skd: Fix checkpatch ERRORS and removed unused functions.
Message-ID: <20131023120232.GB14598@kernel.dk>
References: <87B0A48E21A1974AB4780BA3191524C210E71E@MYMBX3.stec-inc.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87B0A48E21A1974AB4780BA3191524C210E71E@MYMBX3.stec-inc.ad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23 2013, Akhil Bhansali wrote:
> From dcd25c7128e14c90abb6a5d61e0a9ae9b26b6904 Mon Sep 17 00:00:00 2001
> From: Akhil Bhansali <bhansaliakhil@gmail.com>
> Date: Wed, 23 Oct 2013 14:45:34 +0530
> Subject: [PATCH] [PATCH] Fix checkpatch ERRORS and removed unused functions.

In the future, please ensure that patches are sanity cleaned. There's a
double [PATCH] in that subject, and you should prefix the first line
with the driver/area being modified.

I committed it as:

skd: Fix checkpatch ERRORS and removed unused functions.

> This patch fixes checkpatch.pl errors for assignment in if condition.
> It also removes unused readq / readl function calls.
> 
> As Andrew had disabled the compilation of drivers for 32 bit,
> I have modified format specifiers in few VPRINTKs to avoid warnings
> during 64 bit compilation.
> Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
> Reviewed-by: Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>

Leave a line between the commit message and the signed-off/reviewed
lines.

> PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
> 
> This electronic transmission, and any documents attached hereto, may
> contain confidential, proprietary and/or legally privileged
> information. The information is intended only for use by the recipient
> named above. If you received this electronic message in error, please
> notify the sender and delete the electronic message. Any disclosure,
> copying, distribution, or use of the contents of information received
> in error is strictly prohibited, and violators will be pursued
> legally.

And you might want to look into getting rid of this if possible, you are
posting to public lists...

-- 
Jens Axboe

