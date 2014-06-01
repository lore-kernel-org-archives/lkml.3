Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaFASNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:13:35 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40556 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbaFASNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:13:33 -0400
Message-ID: <538B6D48.9060502@linaro.org>
Date: Sun, 01 Jun 2014 19:13:28 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH v5 11/13] mmc: mmci: add explicit clk control
References: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org> <1401470080-27277-1-git-send-email-srinivas.kandagatla@linaro.org> <20140531122945.GA20736@n2100.arm.linux.org.uk>
In-Reply-To: <20140531122945.GA20736@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Russell,

On 31/05/14 13:29, Russell King - ARM Linux wrote:
>>
>> >+	if ((host->variant->explicit_mclk_control) &&
>> >+	    (ios->clock != host->clock_cache)) {
> Please explain what use these parens have (or just get rid of them as
> they're completely unnecessary - they do nothing for readability.)
I agree, will fix this in next version, It was a left over from my 
previous patches which had one more variable in that first check.

Thanks,
srini
