Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3HSWfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:35:15 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:43386 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3HSWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:35:11 -0400
MIME-Version: 1.0
In-Reply-To: <521246D8.9040506@wwwdotorg.org>
References: <1375798370-2231-1-git-send-email-ldewangan@nvidia.com>
	<52014E50.6030508@wwwdotorg.org>
	<5203D138.4030107@nvidia.com>
	<20130808171331.GA6960@core.coreip.homeip.net>
	<5203D487.5020507@wwwdotorg.org>
	<20130812171504.GA31418@core.coreip.homeip.net>
	<52092299.4080104@wwwdotorg.org>
	<52123152.9070408@nvidia.com>
	<521246D8.9040506@wwwdotorg.org>
Date: Mon, 19 Aug 2013 17:35:10 -0500
Message-ID: <CAL_Jsq+Ur8szL=kwtvBq+JzSk_DY=i6g3iBZ0Uu9baordm2-9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] include: dt-binding: input: create a DT header
 defining key codes.
From: Rob Herring <robherring2@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 11:24 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/19/2013 08:53 AM, Laxman Dewangan wrote:
>> On Monday 12 August 2013 11:29 PM, Stephen Warren wrote:
>>> On 08/12/2013 11:15 AM, Dmitry Torokhov wrote:
>>>>>
>>>>> Device tree files can only include headers in include/dt-bindings.
>>>>> Eventually/soon, all the DT files and the headers in the dt-bindings/
>>>>> directory will be split out into a separate git tree, which does not
>>>>> have access to include/uapi, or indeed any other Linux kernel header
>>>>> files.
>>>> OK, that makes it easier for me - please merge through whatever tree
>>>> that owns include/dt-bindings.
>>> Are there any objections to my taking both patches through the Tegra
>>> tree? Patch 2/2 depends on 1/2 and is Tegra-specific. This should work
>>> out fine unless anyone else wants to use the new header this kernel
>>> cycle; if they do, this should go into a topic branch in the DT tree
>>> that I can pull into the Tegra tree.
>>
>> Hi Stephen,
>> Just wanted to check if you are taking this on Tegra tree. I want to
>> post some more cleanups on other dts file  to use dt-binding include for
>> key code otherwise I will defer for next kernel version.
>
> At this time, I assume this will go through the DT repo/branch. Rob?

Applied.

It is available here:
git://sources.calxeda.com/kernel/linux.git for-grant

Rob
