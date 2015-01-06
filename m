Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbbAFWRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:17:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56202 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbbAFWRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:17:05 -0500
Date: Tue, 06 Jan 2015 17:17:02 -0500 (EST)
Message-Id: <20150106.171702.634373983545087688.davem@davemloft.net>
To: eswierk@skyportsystems.com
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: Extend ethtool plugin module eeprom API to
 phylib
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420248476-110859-1-git-send-email-eswierk@skyportsystems.com>
References: <1420248476-110859-1-git-send-email-eswierk@skyportsystems.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 14:17:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ed Swierk <eswierk@skyportsystems.com>
Date: Fri,  2 Jan 2015 17:27:56 -0800

> This patch extends the ethtool plugin module eeprom API to support cards
> whose phy support is delegated to a separate driver.
> 
> The handlers for ETHTOOL_GMODULEINFO and ETHTOOL_GMODULEEEPROM call the
> module_info and module_eeprom functions if the phy driver provides them;
> otherwise the handlers call the equivalent ethtool_ops functions provided
> by network drivers with built-in phy support.
> 
> Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>

Applied to net-next, thanks.
