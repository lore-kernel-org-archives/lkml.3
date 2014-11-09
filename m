Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKIXew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:34:52 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:60491 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaKIXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:34:51 -0500
Date: Mon, 10 Nov 2014 00:34:37 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: e100: Laptop battery drain and WoL settings from EEPROM
Message-ID: <20141109233437.GA5037@electric-eye.fr.zoreil.com>
References: <201411090015.41446.linux@rainbow-software.org>
 <201411091918.04036.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411091918.04036.linux@rainbow-software.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary <linux@rainbow-software.org> :
[...]
> > Looks like this laptop is probably WoL-capable even on battery.
> >
> > Measured the current from AC adapter:
> > around 20mA with WoL inactive (shut down from Windows or by power button in
> > GRUB) around 40mA with WoL active (shut down from Linux)
> >
> > So to work-around this problem, users must disable WoL manually on each
> > boot.

Or configure udev so that ethtool disables WoL.

The current policy has been here for ages. Some users may rely on it.

There must be some strong rationale for their setup to have to be changed.

-- 
Ueimor
