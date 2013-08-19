Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab3HSOhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:37:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19115 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3HSOhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:37:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 Aug 2013 07:35:04 -0700
Message-ID: <52123152.9070408@nvidia.com>
Date: Mon, 19 Aug 2013 20:23:06 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 1/2] include: dt-binding: input: create a DT header defining
 key codes.
References: <1375798370-2231-1-git-send-email-ldewangan@nvidia.com> <52014E50.6030508@wwwdotorg.org> <5203D138.4030107@nvidia.com> <20130808171331.GA6960@core.coreip.homeip.net> <5203D487.5020507@wwwdotorg.org> <20130812171504.GA31418@core.coreip.homeip.net> <52092299.4080104@wwwdotorg.org>
In-Reply-To: <52092299.4080104@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 August 2013 11:29 PM, Stephen Warren wrote:
> On 08/12/2013 11:15 AM, Dmitry Torokhov wrote:
>>>
>>> Device tree files can only include headers in include/dt-bindings.
>>> Eventually/soon, all the DT files and the headers in the dt-bindings/
>>> directory will be split out into a separate git tree, which does not
>>> have access to include/uapi, or indeed any other Linux kernel header files.
>> OK, that makes it easier for me - please merge through whatever tree
>> that owns include/dt-bindings.
> Are there any objections to my taking both patches through the Tegra
> tree? Patch 2/2 depends on 1/2 and is Tegra-specific. This should work
> out fine unless anyone else wants to use the new header this kernel
> cycle; if they do, this should go into a topic branch in the DT tree
> that I can pull into the Tegra tree.

Hi Stephen,
Just wanted to check if you are taking this on Tegra tree. I want to 
post some more cleanups on other dts file  to use dt-binding include for 
key code otherwise I will defer for next kernel version.


Thanks,
Laxman

