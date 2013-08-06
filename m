Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3HFT1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 15:27:17 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55955 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab3HFT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 15:27:15 -0400
Message-ID: <52014E0F.10404@cogentembedded.com>
Date: Tue, 06 Aug 2013 23:27:11 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 6/6] usb: host: tegra: Tegra30 support
References: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com> <1375812518-3847-7-git-send-email-ttynkkynen@nvidia.com> <520141F2.4060907@cogentembedded.com> <52014B89.9040106@nvidia.com>
In-Reply-To: <52014B89.9040106@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/06/2013 11:16 PM, Tuomas Tynkkynen wrote:

> [...]

>>> +	match = of_match_device(tegra_ehci_of_match, &pdev->dev);
>>> +	if (!match) {
>>> +		dev_err(&pdev->dev, "Error: No device match found\n");
>>> +		return -ENODEV;
>>> +	}
>>> +	soc_config = (struct tegra_ehci_soc_config *)match->data;

>>      Aren't casts from 'const void *' automatic?

>> WBR, Sergei

> Indeed they are, but those explicit casts seem to be used in many places in the kernel.

    I suspect people just don't know C well enough. They are also being 
gradually removed.

WBR, Sergei

