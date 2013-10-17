Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3JQOUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:20:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:35281 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3JQOUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:20:39 -0400
Message-ID: <525FF234.8010105@linutronix.de>
Date: Thu, 17 Oct 2013 16:20:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 1/2] dma: cppi41: redo descriptor collection in abort
 case
References: <1382019576-25105-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1382019576-25105-1-git-send-email-bigeasy@linutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 04:19 PM, Sebastian Andrzej Siewior wrote:
> This patch changes the logic here to look on both queues for the
> descriptor.

Daniel, could please look if this solves your suspend / resume warnings?

Sebastian
