Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbbAQA6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:58:21 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:35402 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbbAQA6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:58:20 -0500
X-IronPort-AV: E=Sophos;i="5.09,414,1418112000"; 
   d="scan'208";a="55005310"
Message-ID: <54B9B3AA.5050201@broadcom.com>
Date: Fri, 16 Jan 2015 16:58:18 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Directory for platform specific power management code
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can someone please tell me the best location for platform specific power
management code, e.g., the code that puts a specific SoC into deep sleep.

I'm working on a project for an SoC called Cygnus from Broadcom. I think
arch/arm/mach-bcm/* is the best location, but given that the trend is to
move code from arch directories into drivers/* (e.g., drivers/clk/*), I
thought I would double check here.

Thanks,

Ray
