Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3DVNL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:11:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45200 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3DVNL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:11:26 -0400
Message-ID: <517536F3.5050702@ti.com>
Date: Mon, 22 Apr 2013 09:11:15 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <rui.zhang@intel.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <durgadoss.r@intel.com>
Subject: Re: [PATCHv2 0/3] thermal: lookup temperature
References: <1365027197-2793-1-git-send-email-eduardo.valentin@ti.com> <20130422110647.GB24710@amd.pavel.ucw.cz>
In-Reply-To: <20130422110647.GB24710@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pavel,

On 22-04-2013 07:06, Pavel Machek wrote:
> Hi!
>
>> Here is V2 of temperature lookup helper function. This has been
>> split into two API as suggested on V1.
>>
>> The usage of it is exemplified on patch 03.
>>
>>
>> Eduardo Valentin (3):
>>    thermal: introduce thermal_zone_get_zone_by_name helper function
>
> Is the function name maybe a bit long? Perhaps using tz_ prefix
> instead of "thermal_zone_" would help? or thermal_get_by_name? tz_get_by_name?
>
> 									Pavel
>
This patch follows the naming convention on this file. If we are  going 
to use different prefixes, then I suggest sending a patch that changes 
the functions that are exported by this file. Besides the names you 
suggested do not reflect exactly the purpose of the introduced API.

Thanks for your suggestion.

All best,

Thanks.
