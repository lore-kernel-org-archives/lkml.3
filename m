Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3KTUjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:39:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59228 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3KTUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:39:33 -0500
Message-ID: <528D1DD6.9010808@ti.com>
Date: Wed, 20 Nov 2013 22:38:46 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 0/3] Reuse davinci-nand driver for Keystone arch
References: <1384964699-15134-1-git-send-email-ivan.khoronzhuk@ti.com> <528D18EC.6000501@ti.com> <528D1C94.7010100@ti.com>
In-Reply-To: <528D1C94.7010100@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 10:33 PM, Santosh Shilimkar wrote:
> On Wednesday 20 November 2013 03:17 PM, Grygorii Strashko wrote:
>> On 11/20/2013 06:24 PM, Ivan Khoronzhuk wrote:
>>> This series contains updates of Davinci nand driver, in order to be
>>> reused for Keystone platform.
>>>
>>> Depends on:
>>> - Davinci nand driver fixes and updates:
>>>     https://lkml.org/lkml/2013/11/20/271
>>
>> ^^^^ I suggest to merge this series with above one as it
>> should not break anything.
>>
> I agree. That way the mtd patch series can go
> together nicely.
>
> Regards,
> Santosh
>

Ok, I will combine them

-- 
Regards,
Ivan Khoronzhuk
