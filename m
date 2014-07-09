Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaGIKCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:02:00 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60193 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348AbaGIKBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:01:54 -0400
Date: Wed, 9 Jul 2014 12:01:47 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: devicetree@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and CPSW
Message-ID: <20140709100147.GB25154@breakpoint.cc>
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com>
 <20140709095552.GA25154@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140709095552.GA25154@breakpoint.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-09 11:55:52 [+0200], Sebastian Andrzej Siewior wrote:
> On 2014-07-08 18:46:39 [+0530], Mugunthan V N wrote:
> > Adding hwmod data for CPSW and MDIO which is present in DRA7xx SoC
> 
> I reverted my patch, applied this one and after boot I got:
Oh me dum dum. I had --dry-run…

Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

This is basically what Tony hasked me to do: No IRQ numbers & iomem.

Sebastian
