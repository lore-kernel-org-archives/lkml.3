Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3LDFyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:54:17 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13241 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3LDFyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:54:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Dec 2013 21:51:18 -0800
Message-ID: <529EC2E5.5050909@nvidia.com>
Date: Wed, 4 Dec 2013 11:21:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: tegra: convert device tree file of Dalmore to
 use pinctrl defines
References: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com> <1385992502-12771-2-git-send-email-ldewangan@nvidia.com> <529E3A6E.1050003@wwwdotorg.org>
In-Reply-To: <529E3A6E.1050003@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013 01:39 AM, Stephen Warren wrote:
> On 12/02/2013 06:55 AM, Laxman Dewangan wrote:
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Patch description?
>
> BTW, did you compile all the Tegra DT files before and after this
> change, and make sure that there's zero difference between them (i.e.
> they're identical byte-for-byte when compiled)? I don't feel like
> manually double-checking this entire patch...

I just made changes for the Dalmore only. Not touched Tegra30 and 
Tegra20_ platform dts.

For Dalmore, I compare the binary before and after this change as well 
dts generated back from dtb using dtc.
It is same.
