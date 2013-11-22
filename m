Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3KVBfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:35:48 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6823 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3KVBfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:35:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Nov 2013 17:29:43 -0800
Message-ID: <528EB4EE.309@nvidia.com>
Date: Fri, 22 Nov 2013 10:35:42 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: tegra: switch FUSE clock on before usage
References: <1385001613-19098-1-git-send-email-acourbot@nvidia.com> <528E6D58.6050503@wwwdotorg.org>
In-Reply-To: <528E6D58.6050503@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:30 AM, Stephen Warren wrote:
> On 11/20/2013 07:40 PM, Alexandre Courbot wrote:
>> FUSE clock is enabled by most bootloaders, but we cannot expect it to be
>> on in all contexts (e.g. kexec).
>>
>> Ensure the FUSE clock is enabled before any of its registers is touched.
>> Since FUSE is touched very early during system boot (before the clock
>> devices are registered), directly manipulate the clock register bit in
>> case the clock device cannot be acquired.
>
> This looks reasonable to me. I'll apply it soon after -rc1.

Thanks. Be careful as I noticed I misformatted my commit message. The 
part after the "--" will not be stripped by git am as I intended it to 
be. I understood what I did wrong and will hopefully not make that 
mistake again.

Sorry for the inconvenience.
