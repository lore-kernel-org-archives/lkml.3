Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3FFQgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:36:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35409 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3FFQgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:36:50 -0400
Message-ID: <51B0B8B0.3050503@wwwdotorg.org>
Date: Thu, 06 Jun 2013 10:28:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Joseph Lo <josephl@nvidia.com>, Karan Jhavar <kjhavar@nvidia.com>,
        Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <1740292.8Sz57ytBcM@flatron> <51B0667D.30801@nvidia.com>
In-Reply-To: <51B0667D.30801@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 04:37 AM, Alex Courbot wrote:
> Hi Tomasz,
> 
> On 06/06/2013 07:17 PM, Tomasz Figa wrote:
...
>> I think this patch could be split into several patches:
>>   - add support for firmware
>>   - split reset function
>>   - add reset support using firmware.
> 
> Mmm possibly yes, but I wonder if that would not be too much splitting.
> Stephen?

That's probably fine. It might make bisection easier if there are
regressions.

