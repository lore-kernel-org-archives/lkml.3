Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3HHQ5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:57:30 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9459 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3HHQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:57:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Aug 2013 09:57:28 -0700
Message-ID: <5203D138.4030107@nvidia.com>
Date: Thu, 8 Aug 2013 22:41:20 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 1/2] include: dt-binding: input: create a DT header defining
 key codes.
References: <1375798370-2231-1-git-send-email-ldewangan@nvidia.com> <52014E50.6030508@wwwdotorg.org>
In-Reply-To: <52014E50.6030508@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 August 2013 12:58 AM, Stephen Warren wrote:
> (CC'ing DT bindings maintainers too, hence quoting a bit of the patch)
>
> On 08/06/2013 08:12 AM, Laxman Dewangan wrote:
>> Many of Key device tree bindings uses the constant number as key code
>> which matches with kernel header key code and then comment as follows
>> for reference/better readability:
>> 	linux,code = <102>; /* KEY_HOME */
>>
>> Create a DT header which defines all the key code so that DT key bindings
>> can use it as follows:
>> 	linux,code = <KEY_HOME>;
> This looks fine to me.
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>
> A comment in support of the patch: This is adding OS-specific content to
> the DT. However, the bindings this header file supports are already
> written that way. There's not really any alternative here, since some
> numbering scheme had to be chosen for keycodes, and it may as well be
> the same set as the first/primary OS that'll use the binding.
>
> As far as merging it, this patch should probably go through the core DT
> tree, perhaps in a topic branch so that e.g. Tegra an MVEBU can merge it
> in to apply your subsequent patches (or we can just wait until the next
> kernel release to merge them in).

Do I need to include anyone for this patch to be applied or can go 
through Dmitry's input git branch?

