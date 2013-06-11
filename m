Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3FKSwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:52:49 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:45133 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3FKSws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:52:48 -0400
Message-ID: <51B771FC.1000203@cogentembedded.com>
Date: Tue, 11 Jun 2013 22:52:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "B, Ravi" <ravibabu@ti.com>
CC: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx
 platform
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com> <1370935072-21056-3-git-send-email-ravibabu@ti.com> <51B6E282.9030400@ti.com> <6C6B28D4DC342643927BEAFCE8707BF63EB02C13@DBDE04.ent.ti.com>
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EB02C13@DBDE04.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/11/2013 01:45 PM, B, Ravi wrote:

>>> +
>>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_wkup");
>>> +	phy->phy_wkup = ioremap(res->start, resource_size(res));

>> devm_ioremap?

> The phy_wakeup register is common across two instances of phy, devm_ioremap_resource() will fail to map for twice for same register space.

     I've already told you the register can't be shared between devices 
like this. BTW, you haven't replied to my request concerning your 
/proc/iomem contents...

WBR, Sergei

