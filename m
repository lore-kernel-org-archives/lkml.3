Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab3ETRNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:13:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45903 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab3ETRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:13:04 -0400
Message-ID: <519A599C.2020702@samsung.com>
Date: Tue, 21 May 2013 02:13:00 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 30/33] arch/arm/plat-samsung: don't check resource with
 devm_ioremap_resource
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de> <1368702961-4325-31-git-send-email-wsa@the-dreams.de> <519A517F.5020003@samsung.com> <20130520171118.GA5717@katana>
In-Reply-To: <20130520171118.GA5717@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/13 02:11, Wolfram Sang wrote:
> On Tue, May 21, 2013 at 01:38:23AM +0900, Kukjin Kim wrote:
>> On 05/16/13 20:15, Wolfram Sang wrote:
>>> devm_ioremap_resource does sanity checks on the given resource. No need to
>>> duplicate this in the driver.
>>>
>>> Signed-off-by: Wolfram Sang<wsa@the-dreams.de>
>>
>> Looks good to me, applied into Samsung tree.
>>
>> Wolfram, if you want to take this into your tree, let me know.
>
> It is already upstream :)
>
Oh, OK. Let me drop it in my tree ;-)

Thanks.

- Kukjin
