Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbbAVDJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:09:09 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:56153 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbbAVDJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:09:03 -0500
MIME-Version: 1.0
In-Reply-To: <1421836341-2036-2-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1421836341-2036-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1421836341-2036-2-git-send-email-rebecca.swee.fun.chang@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 22 Jan 2015 12:08:42 +0900
Message-ID: <CAAVeFuJ+sLEELhHF5g4FMUjBZbhdurSvSifv=q0gbT+SvzFjow@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: sch: Consolidate similar algorithms
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 7:32 PM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>

Looks like there has been some confusion due to the adding/removal of
patches on Linus' branch.

I (as well as Mika IIRC) gave my Reviewed-by on an earlier version of
this patch. Has it changed that much that it needs to be reviewed from
start again? If you just fixed it to compile on Linus' latest devel
branch, you can (and should) carry tags over.

Anyway:

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
