Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaDYQGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:06:04 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51358 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaDYQGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:06:00 -0400
X-Auth-Info: jJ2WNUrXj6aVbzfLXp5x2ZqZi7mhbH5Pl0V7lbgxcv8=
From: Marek Vasut <marex@denx.de>
To: Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Date: Fri, 25 Apr 2014 17:50:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Graham Moore <ggrahammoore@gmail.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Insop Song <insop.song@gainspeed.com>,
        Graham Moore <grmoore@altera.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com> <CA+iBjpR=CYd5JRs6u+BCbqicjoMqRwFRFRS7OFxOrYjetg5mgQ@mail.gmail.com> <20140425044703.GD24530@localhost>
In-Reply-To: <20140425044703.GD24530@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404251750.54582.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 25, 2014 at 06:47:04 AM, Huang Shijie wrote:
> On Tue, Apr 22, 2014 at 01:48:21PM -0500, Graham Moore wrote:
> > On Tue, Apr 22, 2014 at 11:55 AM, Marek Vasut <marex@denx.de> wrote:
> > > Are you sure the n25q512a doesn't use FSR ? Do n25q512a{1,8}3 share the
> > > same IDs?
> > 
> > I looked at the datasheet and the n25q512a *does* have the same FSR
> > usage note, so I suppose I should add USE_FSR to it as well.  But how
> > is it working now?  Maybe nobody is actually using that chip.
> > Yes, n25q512a{1,8}3 share the same id, 0x20ba20.
> 
> could use the ext_id to distinguish them ? just as we did for Spansion NOR.
> 
> i dumped out 5 bytes of my n25q256a: 0x20, 0xba, 0x19, 0x10, 0x00.

The q256 and q512 are rather different chips it seems to me ...

Best regards,
Marek Vasut
