Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3KTUeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:34:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46599 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab3KTUeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:34:00 -0500
Message-ID: <528D1C94.7010100@ti.com>
Date: Wed, 20 Nov 2013 15:33:24 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 0/3] Reuse davinci-nand driver for Keystone arch
References: <1384964699-15134-1-git-send-email-ivan.khoronzhuk@ti.com> <528D18EC.6000501@ti.com>
In-Reply-To: <528D18EC.6000501@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 November 2013 03:17 PM, Grygorii Strashko wrote:
> On 11/20/2013 06:24 PM, Ivan Khoronzhuk wrote:
>> This series contains updates of Davinci nand driver, in order to be
>> reused for Keystone platform.
>>
>> Depends on:
>> - Davinci nand driver fixes and updates:
>>    https://lkml.org/lkml/2013/11/20/271
> 
> ^^^^ I suggest to merge this series with above one as it
> should not break anything.
> 
I agree. That way the mtd patch series can go
together nicely. 

Regards,
Santosh
