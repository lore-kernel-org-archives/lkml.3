Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3GQHKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:10:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6586 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3GQHKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:10:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 17 Jul 2013 00:08:43 -0700
Message-ID: <51E64337.6040004@nvidia.com>
Date: Wed, 17 Jul 2013 15:09:43 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] hwmon: (lm90) use macro defines for the status
 bit
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-3-git-send-email-wni@nvidia.com> <20130715185727.4ebde8c4@endymion.delvare> <51E641C7.4000107@nvidia.com>
In-Reply-To: <51E641C7.4000107@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 03:03 PM, Wei Ni wrote:
> On 07/16/2013 12:57 AM, Jean Delvare wrote:
>> Hi Wei, Guenter,
>>
>>> +
>>> +	if ((status & 0x7f) == 0 && (status2 & 0xfe) == 0)
>>> +		return false;
>>
>> It's a bit disappointing to not use the freshly introduced constants.
>> That being said I agree it would make the code hard to read, so you can
>> leave it as is.
> 
> Sorry, I forgot it.
> How about to define:
> #define LM90_STATUS_MASK 0x7f
> #define MAX6696_STATUS2 0xfe

Sorry, it should be "#define MAX6696_STATUS2_MASK 0xfe".

> 
> Or since Guenter is for vacation, I can just leave it as is, and wait
> him back to talk about below issue.
> 
>>
>
