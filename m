Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaATTyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:54:22 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52990 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATTyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:54:20 -0500
Date: Mon, 20 Jan 2014 11:54:16 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: davinci_nand: Remove unnecessary labels from error
 path
Message-ID: <20140120195416.GU8919@ld-irv-0074>
References: <1389773306-7055-1-git-send-email-prabhakar.csengg@gmail.com>
 <20140116213206.GG8919@ld-irv-0074>
 <CA+V-a8u42eNcDoSr42Bq-3JJEdFMXjru-PDpmXqjZEzkoQ=efQ@mail.gmail.com>
 <CA+V-a8sNSKX_W43G7A0zFKq1GX7k25XR2ZxVtxiQyAmLD5Rs4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8sNSKX_W43G7A0zFKq1GX7k25XR2ZxVtxiQyAmLD5Rs4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 01:20:36PM +0530, Prabhakar Lad wrote:
> On Fri, Jan 17, 2014 at 10:46 AM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
> > On Fri, Jan 17, 2014 at 3:02 AM, Brian Norris
> > <computersforpeace@gmail.com> wrote:
> >> On Wed, Jan 15, 2014 at 01:38:26PM +0530, Prabhakar Lad wrote:
> >>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >>>
> >>> This patch removes the unnecessary labels from
> >>> the error path in probe function which did nothing
> >>> than just returning error values, Thus simplifying code
> >>> path and improved readability.
> >>>
> >>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >>
> >> This does not apply to my branch, since some OOM messages have been
> >> dropped. Can you rebase on l2-mtd.git (or linux-next)?
> >>
> > OK I'll rebase it against linux-next and post a v2.
> >
> My Bad was too late, there is already a patch fixing the above issue
> in linux-next

Ah, and my bad on remembering; I thought this looked familiar! :)

> please ignore this patch.

Sure.

Thanks,
Brian
