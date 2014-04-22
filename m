Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaDVSsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:48:24 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62414 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaDVSsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <201404221855.57247.marex@denx.de>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
	<1398175396-7560-2-git-send-email-grmoore@altera.com>
	<201404221855.57247.marex@denx.de>
Date: Tue, 22 Apr 2014 13:48:21 -0500
Message-ID: <CA+iBjpR=CYd5JRs6u+BCbqicjoMqRwFRFRS7OFxOrYjetg5mgQ@mail.gmail.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
From: Graham Moore <ggrahammoore@gmail.com>
To: Marek Vasut <marex@denx.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:55 AM, Marek Vasut <marex@denx.de> wrote:
> Are you sure the n25q512a doesn't use FSR ? Do n25q512a{1,8}3 share the same
> IDs?

I looked at the datasheet and the n25q512a *does* have the same FSR
usage note, so I suppose I should add USE_FSR to it as well.  But how
is it working now?  Maybe nobody is actually using that chip.
Yes, n25q512a{1,8}3 share the same id, 0x20ba20.
