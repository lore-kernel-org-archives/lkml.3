Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3HFTQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 15:16:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9812 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3HFTQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 15:16:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Aug 2013 12:16:28 -0700
Message-ID: <52014B89.9040106@nvidia.com>
Date: Tue, 6 Aug 2013 22:16:25 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 6/6] usb: host: tegra: Tegra30 support
References: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com> <1375812518-3847-7-git-send-email-ttynkkynen@nvidia.com> <520141F2.4060907@cogentembedded.com>
In-Reply-To: <520141F2.4060907@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 09:35 PM, Sergei Shtylyov wrote:
> Hello.
> 
[...]
>>
>> +	match = of_match_device(tegra_ehci_of_match, &pdev->dev);
>> +	if (!match) {
>> +		dev_err(&pdev->dev, "Error: No device match found\n");
>> +		return -ENODEV;
>> +	}
>> +	soc_config = (struct tegra_ehci_soc_config *)match->data;
> 
>     Aren't casts from 'const void *' automatic?
> 
> WBR, Sergei
> 

Indeed they are, but those explicit casts seem to be used in many places in the kernel.
