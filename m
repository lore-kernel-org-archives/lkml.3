Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaGWBYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:24:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42120 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaGWBYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:24:13 -0400
Message-ID: <53CF0EB3.3000706@ti.com>
Date: Tue, 22 Jul 2014 20:24:03 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <linux-kernel@vger.kernel.org>, "'Tobias Klauser'" <tklauser@distanz.ch>,
        "'Tony Lindgren'" <tony@atomide.com>
Subject: Re: [PATCH] mailbox/omap: Use module_platform_driver
References: <1406031223-15759-1-git-send-email-tklauser@distanz.ch> <53CE7C9C.6060107@ti.com> <002901cfa611$0c11c620$24355260$%han@samsung.com>
In-Reply-To: <002901cfa611$0c11c620$24355260$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 07:57 PM, Jingoo Han wrote:
> On Wednesday, July 23, 2014 12:01 AM, Suman Anna wrote:
>> On 07/22/2014 07:13 AM, Tobias Klauser wrote:
>>> Use the module_platform_driver to omit module init/exit boilerplate code.
>>>
>>> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
>>> ---
>>>  drivers/mailbox/mailbox-omap1.c | 13 +------------
>>>  drivers/mailbox/mailbox-omap2.c | 13 +------------
>>>  2 files changed, 2 insertions(+), 24 deletions(-)
>>
>> I have submitted a series that cleans up/consolidates the OMAP mailbox
>> driver [1], and this patch won't be necessary as the same lines get deleted.
> 
> Oh, I see. So, this patch is unnecessary. I hope that Jassi's mailbox framework
> is submitted soon. Thank you.

Yep, its very close now, there is a v9 version posted today. In any
case, the cleanup series is independent of the framework.

regards
Suman

>>
>> [1] http://www.spinics.net/lists/linux-omap/msg108574.html
> 

