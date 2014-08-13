Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaHMPog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:44:36 -0400
Received: from us2.outbound.mailhostbox.com ([162.210.70.57]:52679 "EHLO
	us2.outbound.mailhostbox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbaHMPof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:44:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Aug 2014 21:14:14 +0530
From: pekon@pek-sem.com
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <computersforpeace@gmail.com>, <kernel@stlinux.com>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 0/8] mtd: nand: Support for new DT NAND driver
In-Reply-To: <1407921127-8590-1-git-send-email-lee.jones@linaro.org>
References: <1407921127-8590-1-git-send-email-lee.jones@linaro.org>
Message-ID: <a8fa82ea68d837e52306e6df62f2ed23@pek-sem.com>
User-Agent: Webmail Services/0.4
X-CTCH-RefID: wb
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-CTCH-Score: 0.000
X-CTCH-Rules: WHITE_FROM_RCVD
X-CTCH-Flags: 0
X-CTCH-ScoreCust: 0.000
X-CTCH-SenderID: pekon@pek-sem.com
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalRecipients: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-BlueWhiteFlag: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On Wednesday 13 August 2014 02:41 PM, Lee Jones wrote:
> Hi Brian, Pekon,
>
> I believe all of your queries have either been answered or addressed
> and I am hoping this will be the last submission. :)
>
> /me crosses fingers!
>
> Kind regards,
> Lee
>
> Lee Jones (8):
>    ARM: multi-v7: Enable ST BCH NAND
>    ARM: sti: Add two new clock definitions for use with ST's NAND
>      controllers
>    ARM: sti: Add BCH (NAND Flash) Controller support for STiH41x 
> (Orly)
>      SoCs
>    ARM: sti: Enable BCH NAND for STiH416 B2020-RevE
>    mtd: nand: stm_nand_bch: provide Device Tree documentation
>    mtd: nand: add shared register defines for ST's NAND Controller
>      drivers
>    mtd: nand: stm_nand_bch: add support for ST's BCH NAND controller
>    mtd: nand: stm_nand_bch: provide ST's implementation of Back Block
>      Table
>

Couldn't review the last [Patch 8/8] for ST's BBT implementation as
I'm not familiar with it. But other patches look good. So for them

Reviewed-By: Pekon Gupta <pekon@pek-sem.com>


with regards, pekon


------------------------
Powered by BigRock.com

