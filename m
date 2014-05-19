Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbaESQ7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:59:42 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65345 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaESQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:59:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Generic Configuration Access Mechanism support
Date: Mon, 19 May 2014 18:59:36 +0200
Message-ID: <10203370.xOnWqK3Vx4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140519163223.GP15130@arm.com>
References: <1400422125-2209-1-git-send-email-sthokal@xilinx.com> <20140519163223.GP15130@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8EPn7VegKdrw0YUKv/ZWf7pw4wuj/SUnjsXs5Hwmr4L
 XZNNdZka3pA8TjTwsBX7HBAlajT8q41N3hc13TwGXwRzuLy5QD
 yDvhGTUplSgr3RpyuJCfTV/l4G+gK4AVsaB4sVEDGi8enpDBCD
 1MOwgH+dUuVuCur7zrHhKW6vD+FeDs4x35T+7Y7PLQioGqnFTQ
 wKna4JgJs5UI3IglDfasLcGtqHQx2LeQnA3ihwoO7VVobjVY3/
 gcX1vjbaIJ/LIN1+uqDOUUZAJ2BqW/55MBBptcNfQHHMdnvpKn
 GnKGMmj3hb9G4hsMg4qFPlBh0Jb9wa8DurEZ76yPzDcIie7hTq
 02eNi9Ys9+kI5bhFO164=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 17:32:23 Will Deacon wrote:
> On Sun, May 18, 2014 at 03:08:45PM +0100, Srikanth Thokala wrote:
> > This patch adds support for a generic CAM and ECAM configuration
> > space accesses.
> 
> Looks good to me, thanks Srikanth!
> 
> Arnd: is this the sort of thing you were expecting? The
> ->is_valid_cfg_access callback is a bit horrible, but I can't think of
> anything better.
> 
> I can include this in the next posting of my PCI patches.

Yes, this is roughly what I had in mind, thanks a lot!

I'll comment a bit more on the patch itself

	Arnd
