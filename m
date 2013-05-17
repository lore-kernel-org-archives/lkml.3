Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3EQK4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:56:48 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:41871 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3EQK4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:56:46 -0400
Date: Fri, 17 May 2013 12:56:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Norris <robn@opera.com>
Cc: linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130517125635.67c84437@endymion.delvare>
In-Reply-To: <20130517102706.GC28229@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
	<20130514231626.GA12961@pyro.melbourne.osa>
	<20130515112044.753bb7bb@endymion.delvare>
	<20130515112741.GA23766@pyro.melbourne.osa>
	<20130515214923.036dabdb@endymion.delvare>
	<20130516034455.GA19452@pyro.melbourne.osa>
	<20130517104928.5b135a4f@endymion.delvare>
	<20130517102706.GC28229@pyro.melbourne.osa>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 May 2013 20:27:06 +1000, Robert Norris wrote:
> On Fri, May 17, 2013 at 10:49:28AM +0200, Jean Delvare wrote:
> > Hmm, can you please dump the PCI configuration space of the SMBus
> > controller?
> > 
> > # /sbin/lspci -s 00:1f.3 -xxx
> 
> 00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
> 00: 86 80 9b 26 41 05 80 02 09 00 05 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 41 04 00 00 00 00 00 00 00 00 00 00 14 10 dd 02
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00
> 40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      ^^
Hmm, no, SMI# isn't enabled. Wrong theory.

-- 
Jean Delvare
