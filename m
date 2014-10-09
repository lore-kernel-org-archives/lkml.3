Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbaJIOd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:33:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbaJIOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:33:19 -0400
Date: Thu, 9 Oct 2014 16:33:15 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: devicetree@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, netdev@vger.kernel.org,
        Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFT 0/8] Marvell PXA168 libphy handling and Berlin
 Ethernet
Message-ID: <20141009163315.2a9e1806@free-electrons.com>
In-Reply-To: <1412858346-11334-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1412858346-11334-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Thu,  9 Oct 2014 14:38:58 +0200, Sebastian Hesselbarth wrote:

> This patch series deals with a removing a IP feature that can be found
> on all currently supported Marvell Ethernet IP (pxa168_eth, mv643xx_eth,
> mvneta). The MAC IP allows to automatically perform PHY auto-negotiation
> without software interaction.
> 
> However, this feature (a) fundamentally clashes with the way libphy works
> and (b) is unable to deal with quirky PHYs that require special treatment.
> In this series, pxa168_eth driver is rewritten to completely disable that
> feature and properly deal with libphy provided PHYs. The other two drivers
> are suspect to future patch sets, also removing the code related with it.

Hum, in mvneta, we already disabled the automatic negotiation and use
libphy. What makes you think the current mvneta driver is wrong in this
respect?

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
