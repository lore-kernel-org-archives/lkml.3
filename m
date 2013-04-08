Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab3DHKEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:04:34 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:40112 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964835Ab3DHKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:04:29 -0400
Message-ID: <51629622.3040509@stericsson.com>
Date: Mon, 8 Apr 2013 12:04:18 +0200
From: Jean-Nicolas GRAUX <jean-nicolas.graux@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
References: <1361206222-2341-1-git-send-email-jean-nicolas.graux@stericsson.com> <20130408095601.GP24058@zurbaran>
In-Reply-To: <20130408095601.GP24058@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 11:56 AM, Samuel Ortiz wrote:
> Hi Jean-Nicolas,
>
> On Mon, Feb 18, 2013 at 05:50:22PM +0100, Jean-Nicolas Graux wrote:
>> Provides support for 1801 variant of stmpe gpio port expanders.
>> This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
>> special key or dedicated key function.
>>
>> Note that special/dedicated key function is not supported yet.
>>
>> Change-Id: I6ea89af7b96e9a02478ebec3467291e7d7c510c9
> No Change-Id, please.
>
>> Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
>> ---
>>   drivers/gpio/gpio-stmpe.c             |   52 +++++--
>>   drivers/input/keyboard/stmpe-keypad.c |  267 ++++++++++++++++++++++++++-------
>>   drivers/mfd/Kconfig                   |    1 +
>>   drivers/mfd/stmpe-i2c.c               |    1 +
>>   drivers/mfd/stmpe.c                   |   97 +++++++++++-
>>   drivers/mfd/stmpe.h                   |   49 ++++++
>>   include/linux/mfd/stmpe.h             |    3 +
>>   7 files changed, 398 insertions(+), 72 deletions(-)
> This should be splitted into 3 patches, an mfd one and then an input and a
> gpio one. I would carry all 3 of them through the MFD tree on order to handle
> build dependencies.
>
> Cheers,
> Samuel.
>
Hello Samuel,
Ok, i do the split. I guess i should also rebase on latest 3.9 kernel.

Regards. J-Nicolas.
