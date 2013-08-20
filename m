Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3HTHOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:14:02 -0400
Received: from www.xora.org.uk ([80.68.91.202]:57325 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3HTHN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:13:57 -0400
Message-ID: <52131732.2060306@slimlogic.co.uk>
Date: Tue, 20 Aug 2013 08:13:54 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        linux-omap@vger.kernel.org, Ruslan Bilovol <ruslan.bilovol@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mfd: twl6030-irq: rework and add twl6032 support
References: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com> <20130820010154.GB13324@zurbaran>
In-Reply-To: <20130820010154.GB13324@zurbaran>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/13 02:01, Samuel Ortiz wrote:
> Hi Grygorii,
>
> On Thu, Jul 25, 2013 at 04:15:46PM +0300, Grygorii Strashko wrote:
>> This patch series intorduces twl6030-irq module rework to use Threaded IRQ and
>> linear irq_domain, and adds support for PMIC TWL6032 IRQs.
>>
>> After this patch series TWL6030/6032 IRQs will be supported only for DT boot mode.
>>
>> Changes since v1:
>> - Added new patch "mfd: twl6030-irq: create struct twl6030_irq"
>>    which introduces "struct twl6030_irq" to store all local variables inside it.
>> - Patch "mfd: twl6030-irq: migrate to IRQ threaded handler":
>>    Minor comments applied; fixed twl6030_exit_irq();
>>    The Parent IRQ has been set for each nested IRQ.
>> - Patch "mfd: twl6030-irq: convert to use linear irq_domain":
>>    The irq_find_mapping() is used in twl6030_mmc_card_detect_config()
>>    to get virtual IRQ number.
> This looks good to me. Kevin, Graeme, any further comments/ACKs ?
>
> Cheers,
> Samuel.
>
Yes, it looked good to me as well.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

G

