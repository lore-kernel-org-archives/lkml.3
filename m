Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaEVNSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:18:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46023 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752348AbaEVNSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:18:30 -0400
Date: Thu, 22 May 2014 15:18:28 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        git@xilinx.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] net: macb: Fixes
Message-ID: <20140522131827.GN3582@piout.net>
References: <1399243382-12528-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399243382-12528-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/05/2014 at 15:42:57 -0700, Soren Brinkmann wrote :
> 
> Hi Nicolas,
> 
> I think I found the cause of the issue I told you about. Looks like
> driver and HW are racing (a few more details in the commit message).
> On my way finding that, I found a few more minor issues which are fixed
> in the first patches.
> The last one is "fixing" the actual race. I don't know if I overlooked
> anything here, but this seems to work fine on Zynq.
> 

Tested on at91sam9g45ek with iperf showing good performances. For the
whole series:
Tested-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
