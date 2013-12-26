Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3LZMKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 07:10:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56481 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3LZMKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 07:10:20 -0500
Message-ID: <52BC1BB8.2070007@ti.com>
Date: Thu, 26 Dec 2013 14:06:16 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <grygorii.strashko@ti.com>, <pawel.moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif
References: <1386267092-18615-1-git-send-email-ivan.khoronzhuk@ti.com> <52B18C44.2000305@ti.com> <52B1915A.7060309@ti.com>
In-Reply-To: <52B1915A.7060309@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 02:13 PM, Sekhar Nori wrote:
> On Wednesday 18 December 2013 05:21 PM, ivan.khoronzhuk wrote:
>> Hi, Sekhar
>>
>> This patch is based on "Reuse davinci-nand driver for Keystone arch" series.
>> The series has passed review at https://lkml.org/lkml/2013/12/17/241
>> and can be found at http://git.infradead.org/l2-mtd.git
>>
>> This patch can be still applied on top of the series without conflicts.
>>
>> Can you please pick up the $subject patch if you are OK with it?
>
> I have no problems with the patch and can pick it too, but need ack from
> MTD maintainer (David) as it touches drivers/mtd/ too.
>
> David,
>
> If you do not have the patch, we can resend it.
>
> Thanks,
> Sekhar
>

Hi Brian,

Do you agree if this patch will go through Davinci tree?

This is the last one we need to reuse Davinci Nand driver for Keystone.

-- 
Regards,
Ivan Khoronzhuk
