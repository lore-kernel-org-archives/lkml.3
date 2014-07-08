Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaGHDyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:54:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaGHDyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:54:12 -0400
Date: Mon, 07 Jul 2014 20:54:11 -0700 (PDT)
Message-Id: <20140707.205411.454703094504745447.davem@davemloft.net>
To: bernd.wachter@jolla.com
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <87vbrgewei.fsf@bwachter.lart.info>
References: <87vbrgewei.fsf@bwachter.lart.info>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Jul 2014 20:54:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Wachter <bernd.wachter@jolla.com>
Date: Tue, 01 Jul 2014 22:01:09 +0300

> There's a new version of the Telewell 4G modem working with, but not
> recognized by this driver. 
> 
> Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>

Applied and queued up for -stable, thanks.
