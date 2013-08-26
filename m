Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3HZIpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:45:18 -0400
Received: from smtp1.goneo.de ([212.90.139.80]:41162 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab3HZIpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:45:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.834
From: Lars Poeschel <poeschel@lemonage.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: am335x: support for multiple USB instances, v3
Date: Mon, 26 Aug 2013 10:45:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, george.cherian@ti.com
References: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308261045.07825.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 August 2013 at 21:24:05, Sebastian Andrzej Siewior wrote:
> Hi,
> 
> this series depends on Felipe's master tree and "usb: phy:
> rename nop_usb_xceiv => usb_phy_gen_xceiv" which I posted earlier. I
> created a -rc3 based branch for that patch [0]. If you fine with this
> please let Tony know.
> I updated the child nodes & the phy generic to use two small memory
> spaces instead of one huge as discussed on mailing list in the last
> spin. Patch contains the cppi41 dma driver which seems to work stable
> so far in host mode. Device mode is currently disabled.
> 
> The complete series as used for testing is also available at [1]
> 
> [0] git://git.breakpoint.cc/cgit/bigeasy/linux.git nop_phy-rename
> [1] git://git.breakpoint.cc/cgit/bigeasy/linux.git am335x_usb

Tested-by: Lars Poeschel <poeschel@lemonage.de>
