Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaLSJi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:38:59 -0500
Received: from mx.vmgattei.com ([77.223.18.35]:54706 "EHLO mx.vmgattei.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaLSJi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:38:57 -0500
Message-ID: <5493F229.80605@sirius-es.it>
Date: Fri, 19 Dec 2014 10:38:49 +0100
From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: alex.popov@linux.com
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>
Subject: Re: Disabled LocalPlus Controller (LPC) clock on MPC512x
References: <5475BE5A.4090503@linux.com> <547D98DF.9000708@sirius-es.it> <54901ED3.30207@linux.com>
In-Reply-To: <54901ED3.30207@linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/2014 13:00, Alexander Popov wrote:
> 02.12.2014 13:47, Matteo Facchinetti пишет:
>> On 26/11/2014 12:49, Alexander Popov wrote:
>>> So starting Linux with clk_ignore_unused bootparam
>>> or inserting dummy LPB reading to some initcall is a temporary fix.
>
> In fact clk_ignore_unused bootparam helps to avoid disabling NFC clock.
> The board crash is reproduced again if I perform the following steps:
> 1. disable NFC clock in uboot by clearing NFC_EN bit in SCCR1 register,
> 2. boot Linux with clk_ignore_unused,
> 3. touch any LPB address.
>

Could you see the Reset Status Register (RSR) after board crash?
When boad reset, you may stop uboot in console and then print the value 
of this register.

This could be help to see what happen internally to the microcontroller.

