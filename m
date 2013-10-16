Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab3JPPFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:05:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58327 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3JPPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:05:06 -0400
MIME-Version: 1.0
In-Reply-To: <525D6276.1030507@wwwdotorg.org>
References: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com> <525D6276.1030507@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
Date: Wed, 16 Oct 2013 08:04:43 -0700
Message-ID: <CAPtuhTg5VTqzzoz1kMPx7tzFzW6gjJx+BNnrqmjaG0UR_OH+xQ@mail.gmail.com>
Subject: Re: pull request for tegra clocks (resend with some CCs added this time)
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm happy for the changes to be based on an -rc or clk-next. Either is fine.

Thanks,
Mike

On Tue, Oct 15, 2013 at 8:42 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/15/2013 09:36 AM, Peter De Schrijver wrote:
>> The following changes since commit a0cf1abc25ac197dd97b857c0f6341066a8cb1cf:
>>
>>   Add linux-next specific files for 20130927 (2013-09-27 18:48:50 +1000)
>>
>> are available in the git repository at:
>>   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-0
>
> ??? That won't merge into Mike's tree correctly. The pull request should
> be based on a -rc or final release in the Linus tree, e.g. based on
> v3.12-rc1. Otherwise, if Mike merges this, it will pull in all patches
> from other subsystems that went into linux-next.
