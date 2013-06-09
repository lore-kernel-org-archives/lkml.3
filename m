Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3FIRDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:03:55 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34687 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3FIRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:03:54 -0400
Date: Sun, 9 Jun 2013 10:03:47 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Andrew Chew <achew@nvidia.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/1] tps65090-charger: Fix AC detect
Message-ID: <20130609170347.GA23128@teo>
References: <1370553163-31804-1-git-send-email-achew@nvidia.com>
 <51B2054B.7030609@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51B2054B.7030609@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:07:39PM -0400, Rhyland Klein wrote:
> On 6/6/2013 5:12 PM, Andrew Chew wrote:
> > The VACG interrupt was not being enabled.  Thus, interrupts were never
> > generated when AC status changes.  In addition, interrupts were never
> > cleared after taking and processing the interrupt.
> > 
> > Added the register offset for the INTR_MASK register, since this is needed
> > to unmask the VACG interrupt.
> > 
> > Enabled the VACG interrupt in tps65090_config_charger().
> > 
> > Cleared interrupts after processing, in tps65090_charger_isr().
> > 
> > Also removed unused variable "enable" in tps65090_enable_charging(),
> > and fixed a typo in one of the dev_err() prints.
> > 
> > Signed-off-by: Andrew Chew <achew@nvidia.com>
> > ---
> 
> Great! Tested and it works great on my Dalmore.
> 
> Tested-by: Rhyland Klein <rklein@nvidia.com>
> Acked-by: Rhyland Klein <rklein@nvidia.com>

Applied, thanks!

Anton
