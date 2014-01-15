Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaAOCtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:49:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54587 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaAOCtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:49:31 -0500
Date: Tue, 14 Jan 2014 18:49:29 -0800 (PST)
Message-Id: <20140114.184929.310035945472596324.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: oliver@neukum.org, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] r8152: remove limitation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389753736-2218-1-git-send-email-hayeswang@realtek.com>
References: <1389250232-8663-1-git-send-email-hayeswang@realtek.com>
	<1389753736-2218-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 15 Jan 2014 10:42:13 +0800

> Remove the limitation between ecm mode and vendor mode.
> 
> v2: replace the patch #3 with "ecm and vendor modes coexist".

This looks better, series, applied, thanks.
