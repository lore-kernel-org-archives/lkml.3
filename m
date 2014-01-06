Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbaAFWJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:09:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46636 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaAFWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:09:50 -0500
Message-ID: <52CB29AC.8070406@codeaurora.org>
Date: Mon, 06 Jan 2014 14:09:48 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v4 0/6] Krait L1/L2 EDAC driver
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org> <20140104101901.GA4439@nazgul.tnic>
In-Reply-To: <20140104101901.GA4439@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/14 02:19, Borislav Petkov wrote:
> On Mon, Dec 30, 2013 at 12:14:11PM -0800, Stephen Boyd wrote:
>> This patchset adds support for the Krait L1/L2 cache error detection
>> hardware. The first patch fixes a generic framework bug. The next
>> two patches lay the groundwork for this driver to be added by 
>> exporting percpu irq functions as well as adding the Krait l2 indirection
>> register code. The next two patches add the driver and the binding and 
>> the final patch hooks it all up by adding the device tree node.
>>
>> I'm not sure which tree this is supposed to go through. Ideally we could
>> send the first 3 plus the 5th one through an edac tree.
> Sure, I can take a look at the drivers/edac/ changes but I'd need an ack
> for the arch/arm/ stuff before/if I pick it up, i.e. patch 3.

Ok great. Perhaps Russell King or Mark Rutland can ack the arch/arm patch.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

