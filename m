Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3HHHJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:09:30 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19466 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933594Ab3HHHJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:09:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Aug 2013 00:09:28 -0700
Message-ID: <52034763.9060307@nvidia.com>
Date: Thu, 8 Aug 2013 12:53:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, "kishon@ti.com" <kishon@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: pinconf_generic: add utility functions for
 add map/configs
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com> <1374833754-19659-2-git-send-email-ldewangan@nvidia.com> <51F2B384.9050706@wwwdotorg.org> <CACRpkdYXmccm-4dP4_cVCH-EPhhw9ww811Qu9ZVjZqN+e+8zVQ@mail.gmail.com>
In-Reply-To: <CACRpkdYXmccm-4dP4_cVCH-EPhhw9ww811Qu9ZVjZqN+e+8zVQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 August 2013 11:57 PM, Linus Walleij wrote:
> On Fri, Jul 26, 2013 at 7:36 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 07/26/2013 04:15 AM, Laxman Dewangan wrote:
>>> Some of pincontrol driver needs the utility function to create map
>>> list. The utility function needed for adding mux, configs etc.
> It is a noble goal to unify this and thank you *very* much for taking
> it on.

Thanks Linus,
There is 3 patches of version 3 of same series, if it gets 
concluded/applied then I will have some more patches for removing 
duplicate code from individual driver.


>>
>> I don't think those are the correct files for this code. Presumably
>> there's no reason at all why a pinctrl driver that doesn't require
>> CONFIG_GENERIC_PINCONF can't use these basic utility functions. Perhaps
>> add a new pinctrl-utils file?
> Agree with Stephen, we need to put this in a separate file, such at
> pinctrl-dt.c or just put it into core.c.
>
Version 3 address all these.
Thanks,,
Laxman
