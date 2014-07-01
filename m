Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362AbaGAWih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:38:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030261AbaGAWig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:38:36 -0400
Date: Tue, 01 Jul 2014 15:38:06 -0700 (PDT)
Message-Id: <20140701.153806.1074873302413556163.davem@redhat.com>
To: boris.brezillon@free-electrons.com
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        alexandre.belloni@free-electrons.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ARM: at91: remove phy fixup for sama5d3xek
 boards
From: David Miller <davem@redhat.com>
In-Reply-To: <1403777615-25685-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1403777615-25685-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Date: Thu, 26 Jun 2014 12:13:33 +0200

> This patch removes a board specific hook for sama5d3xek boards from the
> sama5d3 generic DT board file.
> 
> This hook (which register a phy fixup configuring board specific delays
> in the ksz9021 ethernet phy) is now replaced by the appropriate DT
> properties definitions in the sama5d3xcm.dtsi file.
> 
> Changes since v1:
>  - fix txc-skew-ps and rxc-skew-ps delays
>  - remove phy address info to handle Ronetix and Embest HW designs

These patches do not apply cleanly to 'net' nor 'net-next', in fact
you did not even say which tree these changes are targetting.

Please respin these patches and explicitly say what tree you wish
them to be applied to.

Thanks.
