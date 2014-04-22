Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaDVS64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:58:56 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34867 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaDVS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:58:33 -0400
X-Auth-Info: JEX2xMDotjzoB8qJiGdeqtMcB3muMUMCep0t/yBMxBo=
From: Marek Vasut <marex@denx.de>
To: Graham Moore <ggrahammoore@gmail.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Date: Tue, 22 Apr 2014 20:58:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Graham Moore <grmoore@altera.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com> <201404221855.57247.marex@denx.de> <CA+iBjpR=CYd5JRs6u+BCbqicjoMqRwFRFRS7OFxOrYjetg5mgQ@mail.gmail.com>
In-Reply-To: <CA+iBjpR=CYd5JRs6u+BCbqicjoMqRwFRFRS7OFxOrYjetg5mgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404222058.30763.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 at 08:48:21 PM, Graham Moore wrote:
> On Tue, Apr 22, 2014 at 11:55 AM, Marek Vasut <marex@denx.de> wrote:
> > Are you sure the n25q512a doesn't use FSR ? Do n25q512a{1,8}3 share the
> > same IDs?
> 
> I looked at the datasheet and the n25q512a *does* have the same FSR
> usage note, so I suppose I should add USE_FSR to it as well.  But how
> is it working now?

Is it at all ?

> Maybe nobody is actually using that chip.
> Yes, n25q512a{1,8}3 share the same id, 0x20ba20.

Sigh, oh Micron ...

Best regards,
Marek Vasut
