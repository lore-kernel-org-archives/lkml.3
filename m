Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3LBSse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:48:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52934 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LBSsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:48:32 -0500
Date: Mon, 02 Dec 2013 13:48:29 -0500 (EST)
Message-Id: <20131202.134829.2041194874847967680.davem@davemloft.net>
To: mchan@broadcom.com
Cc: rjw@rjwysocki.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com, nsujir@broadcom.com
Subject: Re: [PATCH] PCI / tg3: Give up chip reset and carrier loss
 handling if PCI device is not present
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385930359.6988.7.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <7807315.7cU9KldDtM@vostro.rjw.lan>
	<1385930359.6988.7.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 02 Dec 2013 10:48:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Sun, 1 Dec 2013 12:39:19 -0800

> I'm not familiar with the DS1.  Does the tg3 device get removed through
> tg3_remove_one() in this case?  What happens when you reconnect the DS1?

Michael, is Rafael's explanation sufficient for you?
