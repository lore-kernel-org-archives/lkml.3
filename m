Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaFEM7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:59:20 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11337 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFEM7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:59:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Jun 2014 05:54:09 -0700
Message-ID: <539069A3.9010100@nvidia.com>
Date: Thu, 5 Jun 2014 15:59:15 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, Tejun Heo <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>	<1401881559-18469-9-git-send-email-mperttunen@nvidia.com> <CAL_JsqLh7kqnufNaWKdOEFb=m2mViFX4kTGMHOKmHuTAVMr+fA@mail.gmail.com>
In-Reply-To: <CAL_JsqLh7kqnufNaWKdOEFb=m2mViFX4kTGMHOKmHuTAVMr+fA@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, will remove.

- Mikko

On 05/06/14 15:18, Rob Herring wrote:
> On Wed, Jun 4, 2014 at 6:32 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
>> This adds support for the integrated AHCI-compliant Serial ATA
>> controller present on the NVIDIA Tegra124 system-on-chip.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>
> [...]
>
>> +static int tegra_ahci_probe(struct platform_device *pdev)
>> +{
>> +       const struct of_device_id *match;
>> +       struct ahci_host_priv *hpriv;
>> +       struct tegra_ahci_priv *tegra;
>> +       int ret;
>> +
>> +       match = of_match_device(tegra_ahci_of_match, &pdev->dev);
>
> This is not needed.
>
>> +       if (!match)
>> +               return -EINVAL;
>> +
