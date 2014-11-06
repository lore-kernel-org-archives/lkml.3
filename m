Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKFHzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:55:14 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKFHzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:11 -0500
Message-ID: <545B295B.7020409@nod.at>
Date: Thu, 06 Nov 2014 08:55:07 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Subject: Re: [PATCH 08/35] UBI: Split __wl_get_peb()
References: <1414586758-9972-1-git-send-email-richard@nod.at>	 <1414586758-9972-9-git-send-email-richard@nod.at> <1415260306.958.158.camel@sauron.fi.intel.com>
In-Reply-To: <1415260306.958.158.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2014 um 08:51 schrieb Artem Bityutskiy:
> On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
>> Make it two functions, wl_get_wle() and wl_get_peb().
>> wl_get_peb() works exactly like __wl_get_peb() but wl_get_wle()
>> does not call produce_free_peb().
>> While refilling the fastmap user pool we cannot release ubi->wl_lock
>> as produce_free_peb() does.
>> Hence the fastmap logic uses now wl_get_wle().
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Please, re-consider naming.
> 
> The convention is that non-static function names start with ubi_wl_*.
> Static function names start with _*.
> 
> Also, please add a comment above the functions explaining what it does.

On my TODO list is already a big "enhance comments" item. :)
I'll send an updates series soon.

Thanks,
//richard
