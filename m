Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaHQUfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 16:35:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:35037 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaHQUfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 16:35:20 -0400
Date: Sun, 17 Aug 2014 22:35:12 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140817203512.GA24330@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <20140815181704.GH17769@csclub.uwaterloo.ca>
 <53EE5BF8.3010007@linutronix.de>
 <20140815202826.GC9239@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140815202826.GC9239@atomide.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren | 2014-08-15 13:28:27 [-0700]:

>> It configured the trigger levels to 1 for RX and 16 for TX.
>
>Hmm that weird RX trigger level is a workaround for lost characters.
>
>See commit 0ba5f66836 (tty: serial: OMAP: use a 1-byte RX FIFO
>threshold in PIO mode :)
>
>There's paste test in that commit, I wonder if the 8250 drivers
>can deal with it any better?

I recall that I used it as a console and didn't see any missing chars.
I will try test but I am traveling this week…

>Regards,
>
>Tony

Sebastian
