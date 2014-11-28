Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaK1Aa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:30:29 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39329 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaK1Aa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:30:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,473,1413270000"; 
   d="scan'208";a="51977474"
Message-ID: <5477C215.7040905@broadcom.com>
Date: Thu, 27 Nov 2014 16:30:13 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Ray Jui <rjui@broadcom.com>,
        Corneliu Doban <cdoban@broadcom.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] mtd: nand: added nand_shutdown
References: <sbranden@broadcom.com> <1416511085-3930-1-git-send-email-sbranden@broadcom.com> <20141126091015.GR3212@norris-Latitude-E6410>
In-Reply-To: <20141126091015.GR3212@norris-Latitude-E6410>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-11-26 01:10 AM, Brian Norris wrote:
> +	mtd->_reboot = nand_shutdown;
Ah, I see you added this here.  This is great.  We'll try out your 
patchset on our driver and remove the reboot notifier from it.
