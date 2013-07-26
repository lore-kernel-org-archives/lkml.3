Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab3GZVi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:38:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57025 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760010Ab3GZViu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:38:50 -0400
Message-ID: <51F2EC66.2080200@wwwdotorg.org>
Date: Fri, 26 Jul 2013 15:38:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: palmas: Add DVFS mux setting
References: <1374871308-490-1-git-send-email-achew@nvidia.com> <51F2E74E.2060107@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A12740FB@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763862A12740FB@HQMAIL03.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 03:28 PM, Andrew Chew wrote:
>> On 07/26/2013 02:41 PM, Andrew Chew wrote:
>>> There exists a PRIMARY_SECONDARY_PAD3 in the same register base as
>>> PRIMARY_SECONDARY_PAD2, which controls the function of certain pins.
>>> Add a property for this setting.
>>
>> How does this interact with the pinctrl driver that Laxman just sent for
>> Palmas?
>>
>> https://lkml.org/lkml/2013/7/26/141
>> [PATCH 0/2] pinctrl: palmas: add pincontrol driver
> 
> Thanks for pointing this out.  Given this:
> 
> +Optional properties:
> +- ti,palams-enable-dvfs1: Enable DVFS1. Configure pins for DVFS1 mode.
> +- ti,palams-enable-dvfs2: Enable DVFS2. Configure pins for DVFS2 mode.
> 
> I think his work already encompasses what my patch is supposed to do.
> 
> Abandoning this patch.

OK, that's simple!

Are the existing ti,mux-pad1/ti,mux-pad2 properties already in the
binding redundant with Laxman's pinctrl driver?
