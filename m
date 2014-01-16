Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaAPVcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:32:13 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39218 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAPVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:32:11 -0500
Date: Thu, 16 Jan 2014 13:32:06 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: davinci_nand: Remove unnecessary labels from error
 path
Message-ID: <20140116213206.GG8919@ld-irv-0074>
References: <1389773306-7055-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389773306-7055-1-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 01:38:26PM +0530, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch removes the unnecessary labels from
> the error path in probe function which did nothing
> than just returning error values, Thus simplifying code
> path and improved readability.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This does not apply to my branch, since some OOM messages have been
dropped. Can you rebase on l2-mtd.git (or linux-next)?

Thanks,
Brian
