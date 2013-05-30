Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967324Ab3E3Caw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:30:52 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58863 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967301Ab3E3Cao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:30:44 -0400
Message-ID: <51A6B9A2.8090904@linaro.org>
Date: Thu, 30 May 2013 10:29:54 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
References: <519E0F2A.4070602@linaro.org> <1693841.iH9OWSxHyo@vostro.rjw.lan> <51A55C2B.7050805@linaro.org> <51A5E177.3090809@fold.natur.cuni.cz>
In-Reply-To: <51A5E177.3090809@fold.natur.cuni.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-5-29 19:07, Martin Mokrejs wrote:
> Hanjun Guo wrote:
>> On 2013-5-29 7:30, Rafael J. Wysocki wrote:
>>> On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
>>>> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
>>>> although the chances are small, I think it should be fixed.
>>>>
>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>
>>> This patch isn't necessary any more after the changes queued up for 3.11
>>> in the acpi-hotplug branch of the linux-pm.git tree.
>>
>> Ok, I noticed your patch set, just drop my patch.
> 
> But shouldn't this go to stable at least? I checked linux-3.9.4
> and it applies fine. Whether this is relevant for other stable
> series I will leave up to somebody else. ;)

Hi Rafeal,

What's your opinion on Martin's suggestion?

Thanks
Hanjun

> Martin


