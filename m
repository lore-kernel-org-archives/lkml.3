Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbaJINTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:19:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:21070 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205AbaJINTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:19:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="397614056"
Date: Thu, 9 Oct 2014 16:19:09 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 12/13] tty: serial: 8250: omap: add custom irq handling
Message-ID: <20141009131909.GB9108@kuha.fi.intel.com>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <1412014009-13315-13-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412014009-13315-13-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:06:48PM +0200, Sebastian Andrzej Siewior wrote:
> We have (or will have) custom DMA callbacks in the omap driver due to
> the different behaviour in the RX and TX case. To make this work
> we need a few changes in the IRQ handler to invoke the rx_handler again
> after the "manual" mode or retry the tx_handler again before falling
> back to the manual mode.
> 
> Heikki didn't want to see the extra hacks in the generic / default irq
> handler and Peter wasn't too happy about an OMAP-only IRQ handler. The
> way I planned it is to use this extra IRQ routine only in DMA case. If
> Peter dislike this approach then I hope Heikki doesn't block changes in
> the default IRQ handler :)
> 
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Looks good to me.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>


-- 
heikki
