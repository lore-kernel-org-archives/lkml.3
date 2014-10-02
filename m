Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaJBXTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:19:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:45350 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaJBXTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:19:41 -0400
Date: Fri, 3 Oct 2014 01:19:38 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/13 v10] omap 8250 based UART + DMA
Message-ID: <20141002231938.GA17422@linutronix.de>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <20141002164339.GL3122@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141002164339.GL3122@atomide.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren | 2014-10-02 09:43:39 [-0700]:

>Looks good to me. For the patches that do not yet have my acks, please
>feel free to add:
>
>Reviewed-by: Tony Lindgren <tony@atomide.com>
>Tested-by: Tony Lindgren <tony@atomide.com>
Thanks.

>It's probably best that I queue the .dts changes separately though
>to avoid pointless merge conflicts.

Yeah. There is no real dependency on them except that you need them at
some point :)

>Regards,
>
>Tony

Sebastian
