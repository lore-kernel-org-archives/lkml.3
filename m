Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaEUQK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:10:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60405 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaEUQKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:10:55 -0400
Message-ID: <537CCFCE.7070701@ti.com>
Date: Wed, 21 May 2014 12:09:50 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>, <rdunlap@infradead.org>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>, <olof@lixom.net>,
        <w-kwok2@ti.com>, <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>
Subject: Re: [Patch v4 2/5] Power: reset: add bindings for keystone reset
 driver
References: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com> <5023955.Vhmhn25HgF@wuerfel> <537CCE5A.7030909@ti.com> <13696681.6eGQ96hCX4@wuerfel>
In-Reply-To: <13696681.6eGQ96hCX4@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 12:07 PM, Arnd Bergmann wrote:
> On Wednesday 21 May 2014 19:03:38 Ivan Khoronzhuk wrote:
>>
>> I've slightly confused where should I add these bindings.
>> The main pll controller mostly used by clk driver....
>> As its register set is used also by reset driver it's logically to put 
>> it to bindings/mfd,
>> but pll controller in mfd it's strange....
>>
>> Could you please help to decide where should it be?.
> 
> Put it into Documentation/devicetree/bindings/clock/keystone-pll.txt
> 
I was just about post the same suggestion. Lets do that.

regards,
Santosh

