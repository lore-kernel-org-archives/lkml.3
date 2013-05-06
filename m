Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3EFO0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:26:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58433 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3EFO0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:26:47 -0400
Date: Mon, 06 May 2013 10:26:42 -0400 (EDT)
Message-Id: <20130506.102642.62606210058731110.davem@davemloft.net>
To: Hans-Christoph.Schemmel@gemalto.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET DRIVER: Added support for Cinterion's PLxx WWAN
 Interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <239D7A53E5B17B4BB20795A7977613A4A7EE9993A8@CROEXCFWP04.gemalto.com>
References: <239D7A53E5B17B4BB20795A7977613A4A7EE9993A8@CROEXCFWP04.gemalto.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 May 2013 07:26:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
Date: Mon, 6 May 2013 11:16:46 +0200

> /drivers/net/usb/qmi_wwan.c: Added support for Cinterion's PLxx WWAN Interface by adding QMI_FIXED_INTF with Cinterion's Vendor ID as well as Product ID and WWAN Interface Number.
> 
> Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>

The Subject needs to use lowercase letters for the "prefix: " bit
coming after "[PATCH]" and use a more appropropate area indication.

"qmi_wwan: " would have been more appropriate.

Also, properly text format your commit messages so that lines are no longer
than 80 columns.

Just because it looks like it's properly formatted on your computer screen
doesn't mean it is.
