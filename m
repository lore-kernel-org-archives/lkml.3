Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaKLXSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:18:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48041 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaKLXSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:18:15 -0500
Date: Wed, 12 Nov 2014 18:18:13 -0500 (EST)
Message-Id: <20141112.181813.1072534293888457853.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH] e100: Don't enable WoL by default on Toshiba devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415832445-9524-1-git-send-email-linux@rainbow-software.org>
References: <1415832445-9524-1-git-send-email-linux@rainbow-software.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 15:18:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 12 Nov 2014 23:47:25 +0100

> Enabling WoL on some Toshiba laptops (such as Portege R100) causes battery
> drain after shutdown (WoL is active even on battery). These laptops have the
> WoL bit set in EEPROM ID, causing e100 driver to enable WoL by default.
> 
> Check subsystem vendor ID and if it's Toshiba, don't enable WoL by default
> from EEPROM settings.
> 
> Fixes https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Jeff, are you gonna pick this up?
