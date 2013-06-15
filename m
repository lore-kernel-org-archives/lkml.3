Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3FOV64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 17:58:56 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:59351 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3FOV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 17:58:55 -0400
Message-ID: <51BCE39D.4030505@prisktech.co.nz>
Date: Sun, 16 Jun 2013 09:58:53 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c: vt8500: Add support for I2C bus on Wondermedia
 SoCs
References: <1371246736-5460-1-git-send-email-linux@prisktech.co.nz> <20130615111817.GA2938@katana>
In-Reply-To: <20130615111817.GA2938@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/13 23:18, Wolfram Sang wrote:
> On Sat, Jun 15, 2013 at 09:52:16AM +1200, Tony Prisk wrote:
>> This patch adds support for the I2C bus controllers found on Wondermedia
>> 8xxx-series SoCs. Only master-mode is supported.
>>
>> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
>> ---
> ...
>
>> +/* REG_TR */
>> +#define SCL_TIMEOUT(x)		(((x) & 0xFF) << 16)
> I assume this should be << 8 since all regs are 16 bit wide.
>
> Fixed it locally and ready to apply. Please confirm or send a proper
> fix. Rest looks fine.
>
> Thanks for the submission!
>
It should be << 8. Please apply your locally corrected version.

Regards
Tony Prisk
