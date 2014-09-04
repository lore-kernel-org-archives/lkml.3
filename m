Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaIDThY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:37:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55648 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbaIDThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:37:22 -0400
Message-ID: <5408BF77.1020007@wwwdotorg.org>
Date: Thu, 04 Sep 2014 13:37:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Move AHB Kconfig to drivers/amba
References: <1406643934-16301-1-git-send-email-thierry.reding@gmail.com> <53D7C9EE.60503@wwwdotorg.org> <53FB7288.9050002@wwwdotorg.org>
In-Reply-To: <53FB7288.9050002@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 11:29 AM, Stephen Warren wrote:
> On 07/29/2014 10:21 AM, Stephen Warren wrote:
>> On 07/29/2014 08:25 AM, Thierry Reding wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> This will allow the Kconfig option to be shared among 32-bit and 64-bit
>>> ARM.
>>
>> This seems fine to me. I'd expect to apply it for 3.18, provided I get
>> an ack from Russell as drivers/amba maintainer (hence CCing him without
>> trimming the quote).
>
> Russell,
>
> Are you OK with this patch? If so, if you could ack it so I can apply
> it, that would be great.

Russell?
