Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaJYSdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:33:00 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:44491 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaJYSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:32:57 -0400
Date: Sat, 25 Oct 2014 14:59:01 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/8] MIPS: Alchemy: Remove direct access to
 prepare_count field of struct clk
Message-ID: <20141025125901.GC16738@linux-mips.org>
References: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
 <1413812442-24956-2-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413812442-24956-2-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 03:40:01PM +0200, Tomeu Vizoso wrote:

> Replacing it with a call to __clk_is_prepared(), which isn't entirely
> equivalent but in practice shouldn't matter.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

I'm going to merge this via the MIPS tree so it's going to receive some
testing.

Thanks,

  Ralf
