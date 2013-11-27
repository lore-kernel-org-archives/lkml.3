Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3K0ORs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:17:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44235 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3K0ORq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:17:46 -0500
Message-ID: <5295FEE4.8090108@ti.com>
Date: Wed, 27 Nov 2013 09:17:08 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH] watchdog: davinci: rename platform driver to davinci-wdt
References: <1385559113-4354-1-git-send-email-ivan.khoronzhuk@ti.com> <5295FB0E.4070406@ti.com>
In-Reply-To: <5295FB0E.4070406@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 November 2013 09:00 AM, Sekhar Nori wrote:
> On Wednesday 27 November 2013 07:01 PM, Ivan Khoronzhuk wrote:
>> As we switch to use the watchdog core which permits more than one
>> active watchdog in the system, rename platform driver to
>> "davinci-wdt" to be identifiable.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> 
> Looks good to me. Since bulk of this patch touches mach-davinci, I would
> like to take this through my tree to avoid conflicts with other
> mach-davinci patches I accept.
> 
Sounds good. Thanks Sekhar !!

Regards,
Santosh
