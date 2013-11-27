Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3K0Lwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:52:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40677 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab3K0Lwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:52:41 -0500
Message-ID: <5295DCB9.7030708@ti.com>
Date: Wed, 27 Nov 2013 13:51:21 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 00/10] Reuse davinci-nand driver for Keystone arch
References: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com> <20131127013309.GT9468@ld-irv-0074.broadcom.com>
In-Reply-To: <20131127013309.GT9468@ld-irv-0074.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:33 AM, Brian Norris wrote:
> Hi Ivan,
>
> On Thu, Nov 21, 2013 at 01:28:15PM +0200, Ivan Khoronzhuk wrote:
>> This series contains fixes and updates of Davinci nand driver in
>> order to reuse it for Keystone platform.
>>
>> The series is combination of two following series:
>> - Davinci nand driver fixes and updates:
>>    https://lkml.org/lkml/2013/11/20/271
>> - Reuse davinci-nand driver for Keystone arch
>>    https://lkml.org/lkml/2013/11/20/315
>
> Can you make sure to consistently change the email $subject for your
> patch series? For each of the above, it looks like they are actually
> version 2, yet they still just say "[PATCH X/Y]" (not "[PATCH v2 X/Y]").
> This makes it harder to parse the history of each series. (And the
> combining of two un-versioned patch series adds to the confusion.)
>
> Now, this combined series has a good v2 marking (although at this point,
> is it really v3? ...whatever, it doesn't matter). Please continue to
> write appropriate $subjects for this and future patch series.
>
> Thanks,
> Brian
>

Sorry for the mess, I will

-- 
Regards,
Ivan Khoronzhuk
