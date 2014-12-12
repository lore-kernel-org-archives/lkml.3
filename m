Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaLLVMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:12:10 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:50557 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaLLVMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:12:07 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] e100: Don't enable WoL by default on Toshiba devices
Date: Fri, 12 Dec 2014 22:11:26 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: David Miller <davem@davemloft.net>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1415832445-9524-1-git-send-email-linux@rainbow-software.org> <20141112.181813.1072534293888457853.davem@davemloft.net> <1415849927.2454.14.camel@jtkirshe-mobl>
In-Reply-To: <1415849927.2454.14.camel@jtkirshe-mobl>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412122211.27074.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 04:38:47 Jeff Kirsher wrote:
> On Wed, 2014-11-12 at 18:18 -0500, David Miller wrote:
> > From: Ondrej Zary <linux@rainbow-software.org>
> > Date: Wed, 12 Nov 2014 23:47:25 +0100
> >
> > > Enabling WoL on some Toshiba laptops (such as Portege R100) causes
> > > battery drain after shutdown (WoL is active even on battery). These
> > > laptops have the WoL bit set in EEPROM ID, causing e100 driver to
> > > enable WoL by default.
> > >
> > > Check subsystem vendor ID and if it's Toshiba, don't enable WoL by
> > > default from EEPROM settings.
> > >
> > > Fixes https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > Jeff, are you gonna pick this up?
>
> Yes, sorry I did not catch it earlier.

Will this go in 3.19?

-- 
Ondrej Zary
