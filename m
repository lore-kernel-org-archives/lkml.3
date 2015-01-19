Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbbASULM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:11:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33929 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:11:09 -0500
Date: Mon, 19 Jan 2015 15:11:06 -0500 (EST)
Message-Id: <20150119.151106.822126941934010309.davem@davemloft.net>
To: m-karicheri2@ti.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 0/4] net: Add Keystone NetCP ethernet
 driver support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421367007-19744-1-git-send-email-m-karicheri2@ti.com>
References: <1421367007-19744-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Jan 2015 12:11:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Thu, 15 Jan 2015 19:10:03 -0500

> The Network Coprocessor (NetCP) is a hardware accelerator that processes
> Ethernet packets. NetCP has a gigabit Ethernet (GbE) subsystem with a ethernet
> switch sub-module to send and receive packets. NetCP also includes a packet
> accelerator (PA) module to perform packet classification operations such as
> header matching, and packet modification operations such as checksum
> generation. NetCP can also optionally include a Security Accelerator(SA)
> capable of performing IPSec operations on ingress/egress packets.
>     
> Keystone SoC's also have a 10 Gigabit Ethernet Subsystem (XGbE) which
> includes a 3-port Ethernet switch sub-module capable of 10Gb/s and
> 1Gb/s rates per Ethernet port.
>     
> Both GBE and XGBE network processors supported using common driver. It
> is also designed to handle future variants of NetCP.

Series applied to net-next, thanks.
