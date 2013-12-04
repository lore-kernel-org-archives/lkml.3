Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3LDFu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:50:26 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12394 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3LDFuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:50:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Dec 2013 21:43:45 -0800
Message-ID: <529EC1FD.2080806@nvidia.com>
Date: Wed, 4 Dec 2013 11:17:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH] ARM: tegra: convert device tree files to use key defines
References: <1385989797-10879-1-git-send-email-ldewangan@nvidia.com> <529E393C.4010604@wwwdotorg.org>
In-Reply-To: <529E393C.4010604@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013 01:34 AM, Stephen Warren wrote:
> On 12/02/2013 06:09 AM, Laxman Dewangan wrote:
>> Use key code macros for all key code refernced for keys.
>>
>> For tegra20-seaboard.dts and tegra20-harmony.dts:
>>    The key comment for key (16th row and 1st column) is KEY_KPSLASH but
>>    code is 0x004e which is the key code for KEY_KPPLUS. As there other
>>    key exist with KY_KPPLUS, I am assuming key code is wrong and comment
>>    is fine. With this assumption, I am keeping the key code as KEY_KPSLASH.
> This looks reasonable, and I'll apply it soon. What is the patch based
> on? Note that I recently sent a patch to fix the sort order of DT nodes
> in all Tegra DT files, which I'll apply early since it's a cleanup, and
> IIRC some of the KBC nodes may have been moved by that patch, so this
> may conflict. I'll see if I can rebase while applying it.
I worked on linux-next of 20131202.

If there is any issue,  I can generate new patch based on the branch 
which you suggest.

