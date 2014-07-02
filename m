Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbaGBQzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:55:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45060 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964867AbaGBQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:55:31 -0400
Date: Wed, 2 Jul 2014 18:55:28 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/33] clk: at91: main: warn when the main crystal
 frequency is not set
Message-ID: <20140702185528.5699843a@bbrezillon>
In-Reply-To: <20140702163842.7440.73162@quantum>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1404223962-30471-4-git-send-email-alexandre.belloni@free-electrons.com>
	<20140702101811.2f2a507e@bbrezillon>
	<20140702163842.7440.73162@quantum>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2014 09:38:42 -0700
Mike Turquette <mturquette@linaro.org> wrote:

> Quoting Boris BREZILLON (2014-07-02 01:18:11)
> > On Tue,  1 Jul 2014 16:12:12 +0200
> > Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> > 
> > > When the main crystal frequency is not set, the main clock is
> > > approximated using the MAINF value in the CKGR_MCFR register. Warn
> > > the user in that case.
> > > 
> > > Signed-off-by: Alexandre Belloni
> > > <alexandre.belloni@free-electrons.com> ---
> > 
> > Acked-by: Boris BREZILLON <boris.brezillon@overkiz.com>
> > 
> > Mike, do you want me to take this patch and send you a pull request, or
> > should I let you take this one directly ?
> 
> I've picked it up since it is just the one patch.
> 

Thanks.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
