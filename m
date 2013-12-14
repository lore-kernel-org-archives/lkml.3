Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3LNTSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:18:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53532 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3LNTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:18:18 -0500
Message-ID: <52ACAED4.7000305@ti.com>
Date: Sat, 14 Dec 2013 14:17:40 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <wim@iguana.be>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/5] Update Davinci watchdog driver
References: <1386185970-14488-1-git-send-email-ivan.khoronzhuk@ti.com> <52A5EF6B.6060700@ti.com>
In-Reply-To: <52A5EF6B.6060700@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim,

On Monday 09 December 2013 11:27 AM, Santosh Shilimkar wrote:
> Wim,
> 
> On Wednesday 04 December 2013 02:39 PM, Ivan Khoronzhuk wrote:
>> These patches are intended to update Davinci watchdog to use WDT core
>> and reuse driver for keystone arch, because Keystone uses the similar
>> IP like Davinci.
>>
> 
> [..]
> 
>> v4..v5:
>> - watchdog: davinci: change driver to use WDT core
>> 	switched off CONFIG_WATCHDOG_NOWAYOUT option
>>
> Can you please apply the series to your watchdog tree ?
> Do let me know if you want us to prepare a git branch
> to pull from.
> 
ping..

Regards,
Santosh
