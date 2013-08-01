Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3HAMho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:37:44 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:47890 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3HAMhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:37:42 -0400
Message-ID: <51FA569A.9080705@cogentembedded.com>
Date: Thu, 01 Aug 2013 16:37:46 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH 2/2] ARM: dts: USB for Tegra114 Dalmore
References: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com> <1375292543-7896-3-git-send-email-ttynkkynen@nvidia.com> <51F9550F.3080503@cogentembedded.com> <51F9660C.6090604@iki.fi> <51F96B48.10209@cogentembedded.com> <51F98A78.9060309@wwwdotorg.org> <51F98D92.3010607@cogentembedded.com> <51F99DE4.7010503@wwwdotorg.org>
In-Reply-To: <51F99DE4.7010503@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-08-2013 3:29, Stephen Warren wrote:

>>>>      Don't they cause numerous resource conflicts while device nodes
>>>> being
>>>> instantiated as the platform devices?
>>
>>> No; the driver knows that the HW is screwy and there's lots of
>>> register-range sharing going on, so it simply maps the registers, rather
>>> than reserving the physical address range and mapping it.
>>
>>     Yes, it's clear that the driver should take special measures, I was
>> asking about the platform device creation phase. What do you see in
>> /proc/iomem?

> The drivers don't request the memory region since doing so would cause
> conflicts. Hence, the regions don't show up in /proc/iomem.

    Regions should show up after the platform device registration. They just 
show up as subregions of those when you request them. That's why I asked for 
your /proc/iomem.

WBR, Sergei

