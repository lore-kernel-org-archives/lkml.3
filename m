Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3BUM6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 07:58:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17821 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3BUM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 07:58:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Feb 2013 04:53:46 -0800
Message-ID: <512619EB.4030103@nvidia.com>
Date: Thu, 21 Feb 2013 18:28:19 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 00/12] Tegra114 clockframework
References: <1360931849-7090-1-git-send-email-pdeschrijver@nvidia.com> <5123C6E7.9070407@wwwdotorg.org>
In-Reply-To: <5123C6E7.9070407@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013 12:09 AM, Stephen Warren wrote:
> On 02/15/2013 05:36 AM, Peter De Schrijver wrote:
>> This is the seventh version of the Tegra114 clockframework. It is based on the
>> for-next branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git and
>> http://www.spinics.net/lists/arm-kernel/msg220452.html.
> Mike,
>
> I think it'd be prudent to take this series through the Tegra tree again
> for 3.10; patch 11 needs to go in as part of the series due to internal
> dependencies, and I'm slightly worried that other Tegra DT changes might
> conflict with that patch (if only for context). Taking this series (and
> any other Tegra clk driver changes for 3.10) through the Tegra tree
> could resolve that easily. Do you have a problem with that?
>
> If that's OK, can you stage the dependency Peter mentioned:
> http://www.spinics.net/lists/arm-kernel/msg220452.html
> into a stable branch for me to merge, obviously after 3.9-rc1 is out.
>
> Thanks.
>
> Prashant, could you provide a review/ack for this series too.

For the series

Reviewed-by: Prashant Gaikwad <pgaikwad@nvidia.com>


