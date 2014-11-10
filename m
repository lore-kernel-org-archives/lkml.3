Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaKJIPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:15:10 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:35097 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaKJIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:15:08 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: e100: Laptop battery drain and WoL settings from EEPROM
Date: Mon, 10 Nov 2014 09:14:38 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201411090015.41446.linux@rainbow-software.org> <201411091918.04036.linux@rainbow-software.org> <20141109233437.GA5037@electric-eye.fr.zoreil.com>
In-Reply-To: <20141109233437.GA5037@electric-eye.fr.zoreil.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201411100914.38486.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2014, Francois Romieu wrote:
> Ondrej Zary <linux@rainbow-software.org> :
> [...]
>
> > > Looks like this laptop is probably WoL-capable even on battery.
> > >
> > > Measured the current from AC adapter:
> > > around 20mA with WoL inactive (shut down from Windows or by power
> > > button in GRUB) around 40mA with WoL active (shut down from Linux)
> > >
> > > So to work-around this problem, users must disable WoL manually on each
> > > boot.
>
> Or configure udev so that ethtool disables WoL.

This is inconsistent with other (non-Intel) ethernet drivers where users need 
to use ethtool only if they want to enable WoL.
Installing ethtool and writing udev rules just to make a laptop shutdown 
properly is not very user-friendly.

> The current policy has been here for ages. Some users may rely on it.
>
> There must be some strong rationale for their setup to have to be changed.

Yes, that might be a problem.

-- 
Ondrej Zary
