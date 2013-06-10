Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3FJQgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:36:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35443 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3FJQgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:36:01 -0400
Message-ID: <51B6006D.7010409@wwwdotorg.org>
Date: Mon, 10 Jun 2013 10:35:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Chris Johnson <CJohnson@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varun Wadekar <vwadekar@nvidia.com>, Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <51B0BC80.9040007@wwwdotorg.org> <CAAVeFu+by44HnOzv_85kwgeCx5b9TxiMhr27x69QcUj9GRbk8A@mail.gmail.com> <51B20B46.4030501@wwwdotorg.org> <CAAVeFu+UMZikdWO20c9chvBcieOAUgOhz-nTEUpevFWnPNC_ZA@mail.gmail.com> <20130610091415.GS18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130610091415.GS18614@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 03:14 AM, Russell King - ARM Linux wrote:
> On Mon, Jun 10, 2013 at 05:11:15PM +0900, Alexandre Courbot wrote:
>> On Sat, Jun 8, 2013 at 1:33 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>>> I think we need to separate the concept of support for *a* secure
>>>>> monitor, from support for a *particular* secure monitor.
>>>>
>>>> Agreed. In this case, can we assume that support for a specific secure
>>>> monitor is not arch-specific, and that this patch should be moved
>>>> outside of arch-tegra and down to arch/arm? In other words, the ABI of
>>>> a particular secure monitor should be the same no matter the chip,
>>>> shouldn't it?
>>>
>>> I would like to believe that the Trusted Foundations monitor had the
>>> same ABI irrespective of which Soc it was running on. However, I have
>>> absolutely no idea at all if that's true. Even if there's some common
>>> subset of the ABI that is identical across all SoCs, I wouldn't be too
>>> surprised if there were custom extensions for each different SoC, or
>>> just perhaps even each product.
>>>
>>> Can you research this and find out the answer?
>>
>> Will do. Information about TF is scarce unfortunately.
> 
> The answer is... there isn't a common ABI.  That is something I pressed
> ARM Ltd for when this stuff first appeared and they were adamant that
> they were not going to specify any kind of ABI for this interface.

Right, there certainly isn't a common ABI across all secure monitors,
but in this case I was wondering something more specific: whether for
this specific implementation/provider of a secure monitor, if they had a
consistent ABI across all SoCs (or even boards) that they implemented it on.
