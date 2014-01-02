Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaABUU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:20:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55238 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaABUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:20:23 -0500
Message-ID: <52C5CA05.5080803@codeaurora.org>
Date: Thu, 02 Jan 2014 12:20:21 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: arm@kernel.org, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] tty: serial: Limit msm_serial_hs driver to platforms
 that use it
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org> <1388438133-431-4-git-send-email-sboyd@codeaurora.org> <201401021910.22651.arnd@arndb.de>
In-Reply-To: <201401021910.22651.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/14 10:10, Arnd Bergmann wrote:
> On Monday 30 December 2013, Stephen Boyd wrote:
>> The msm_serial_hs driver uses mach specific dma APIs. This is not
>> compatible with the multi-platform ARM effort. Let's only compile
>> this driver on MSM devices that are prepared to support it;
>> allowing the DT based MSM devices to enter the multi-platform ARM
>> build.
>>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Do you have a plan to deal with this in the future? Aren't you going
> to need it in the future on modern SoCs?
>

Yes, we plan to add the code for dma based serial devices into the
msm_serial.c driver. In the process we'll use the linux DMA apis instead
of using mach specific ones.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

