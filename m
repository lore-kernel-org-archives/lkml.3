Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3F0TVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:21:09 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:52683 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753654Ab3F0TVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:21:07 -0400
Date: Thu, 27 Jun 2013 21:21:04 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Guenter Roeck <linux@roeck-us.net>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Xilinx watchdog changes
Message-ID: <20130627192104.GA30433@spo001.leaseweb.com>
References: <cover.1369979787.git.michal.simek@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1369979787.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> The patchset fixes license header and add 1.00.a IP to compatible
> list.
> 
> Thanks for your review,
> Michal
> 
> Remove the 3rd patch from this series which incorrectly
> tried to support set timeout feature.
> 
> Changes in v2:
> - Extend compatible list with 1.00.a instead of replacing 1.01.a
>   reported by Guenter Roeck <linux@roeck-us.net>
> 
> Michal Simek (2):
>   watchdog: xilinx: Fix driver header
>   watchdog: xilinx: Setup the origin compatible string
> 
>  drivers/watchdog/of_xilinx_wdt.c | 31 +++++++++++--------------------
>  1 file changed, 11 insertions(+), 20 deletions(-)

Both patches added to linux-watchdog-next.

Kind regards,
Wim.

