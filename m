Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaEIDAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:00:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32910 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaEIDAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:00:09 -0400
Date: Thu, 08 May 2014 23:00:07 -0400 (EDT)
Message-Id: <20140508.230007.1457921998245217898.davem@davemloft.net>
To: reksio@newterm.pl
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/1] Driver for Beckhoff CX5020 EtherCAT master
 module.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506202450.GM1156@newterm.pl>
References: <20140506202450.GM1156@newterm.pl>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 May 2014 20:00:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darek Marcinkiewicz <reksio@newterm.pl>
Date: Tue, 6 May 2014 22:24:50 +0200

> This driver adds support for EtherCAT master module located on CCAT
> FPGA found on Beckhoff CX series industrial PCs. The driver exposes
> EtherCAT master as an ethernet interface.
> 
> EtherCAT is a fieldbus protocol defined on top of ethernet and Beckhoff
> CX5020 PCs come with built-in EtherCAT master module located on a FPGA,
> which in turn is connected to a PCI bus.
> 
> Signed-off-by: Dariusz Marcinkiewicz <reksio@newterm.pl>

Applied, thanks Dariusz.
