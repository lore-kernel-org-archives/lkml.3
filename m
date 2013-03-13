Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab3CMSzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:55:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40880 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab3CMSzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:55:48 -0400
Message-ID: <5140CBB0.3000204@wwwdotorg.org>
Date: Wed, 13 Mar 2013 12:55:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7 2/2] mfd: syscon: Add non-DT support
References: <1363196060-1149-1-git-send-email-shc_work@mail.ru> <1363196060-1149-2-git-send-email-shc_work@mail.ru> <5140C65C.3040705@wwwdotorg.org> <1363200208.124789915@f299.mail.ru>
In-Reply-To: <1363200208.124789915@f299.mail.ru>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 12:43 PM, Alexander Shiyan wrote:
>> On 03/13/2013 11:34 AM, Alexander Shiyan wrote:
>>> This patch allow using syscon driver from the platform data, i.e.
>>> possibility using driver on systems without oftree support.
>>> For search syscon device from the client drivers,
>>> "syscon_regmap_lookup_by_pdevname" function was added.
>>
>> This patch also removes the driver's remove() function, which isn't
>> mentioned in the commit description.
> 
> Driver is using resource managed functions, remove() is not necessary.

Ah right, I see that conversion was made in this patch. It seems like it
should be mentioned in the commit description, but it's probably not a
big deal unless there is some other reason to repost this.

