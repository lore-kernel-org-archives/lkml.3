Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaFKLLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:11:50 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:41247 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaFKLLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:11:49 -0400
Message-ID: <53983970.4050502@linaro.org>
Date: Wed, 11 Jun 2014 12:11:44 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 1/2] clk: qcom: add clocks necessary for apq8064 sdcc
References: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org> <1402433906-19309-2-git-send-email-sboyd@codeaurora.org> <53981DE1.3070007@suse.de>
In-Reply-To: <53981DE1.3070007@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/06/14 10:14, Andreas Färber wrote:
>> This patch adds clocks necessary for SD card controller on apq8064 SOC.
>> >Without this patch the clocks are visible to the sdcc driver.
> Was this maybe meant to read "invisible"?

You are correct it was suposed to be not visible, will fix it.

>
> Regards,
> Andreas
>
